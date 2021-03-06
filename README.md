## Automatic Subtitles Generation and Synchronization with AWS Transcribe

### Intro
[AWS Transcribe](https://aws.amazon.com/transcribe/) allows to automaticaly convert speech to text using their own Machine Learning trained model. <br />
Using it, I created a project to generate and synchronize subtitles from a given video as an input file. <br />
This repo contains the Terraform templates in order to deploy the solution in AWS, as well as the code used for the Lambdas and the code used by the ECS (on Fargate) from a home-made Docker image uploaded to ECR.

### Basic idea
1. Put a video file as input in a S3 folder.
2. Get the result as a `.srt` file.

### Architecture
#### Schema
![architecture](./readme_assets/aws_subtitles_infrastructure.png)

#### Workflow
1. The user puts the input video file into the [`app_bucket`](infrastructure/compositions/buckets/main.tf) under `inputs/`.
2. This triggers the [`input_to_sqs`](./code/lambdas/input_to_sqs/main.py) Lambda which will send the key path of the input file into the [`sqs_input`](./infrastructure/compositions/media_processing/sqs.tf) queue.
3. A message received in this queue triggers the [`trigger_ecs_task`](./code/lambdas/trigger_ecs_task/main.py) Lambda. The function will
   1. read and parse the message from the SQS Queue.
   2. trigger an ECS task and passing the values (key pahth and Bucket name) fetched from the SQS to it.
4. The ECS task will download the input file into its local FS, extract the sound from it and upload the `.mp3` result under `/tmp` of the `app_bucket`.
5. Once a message is put under `tmp/` the [`trigger_transcribe_job`](./code/lambdas/trigger_transcribe_job/main.py) starts the Transcribe job and send to it the key path of the extracted sound as well as the Bucket name.
6. The Transcribe job starts with the arguments given to it (key path of the `.mp3` file and the Bucket name).
7. Once the Transcribe job is done, its result is uploaded into the [`transcribe_result_bucket`](infrastructure/compositions/buckets/main.tf).
8. This result needs to be parsed into a `.srt` format. This is the job of the [`parse_transcribe_result`](code/lambdas/parse_transcribe_result/main.py) which is triggered by a Bucket notification when a file is uploaded into the root of the `transcribe_result_bucket`.
9. Finally, the parsed and synchronized `.srt` file from the uploaded input video is uploaded into the `transcribe_result_bucket` under `results/`.


### Repository explanations
- [./code](./code) <br />
The code directory is composed if 3 sub-directories: docker, lambdas and local.

   - [/lambdas](./code/lambdas) <br />
This directory contains the Python code used by the AWS Lambdas.

   - [/local](./code/local) <br />
This folder was my starting point, and was used to validate my initial idea. <br />
It contains the Python code to locally test the Transcribe job. It takes a video path as an input and calls the AWS API to receive the .srt final result. <br />
To use it, export your AWS profile into the shell, create a S3 Bucket, fill-up [config.json](./code/local/config.json) and execute the Transcribe job - `python3 transcribe.py`.

   - [/docker](./code/docker) <br />
This part contains the Python code which is used by the ECS task to extract the sound from the video. The Dockerfile is used to built the Docker container which needs to be pused to the ECR repo. <br />

- [./infrastructure](./infrastructure) <br />
This directory contains all the necessary templates and resources to deploy the infrastructure on AWS.

   - [/compostions](./infrastructure/compositions) <br />
   Logical units of Terraform code. Each parts define some Terraform `modules` which call a group of Terraform `resources` defined in [./infrastructure/resources](./infrastructure/resources). For example, in `buckets` we can find the code used to deploy each S3 Buckets used by the solution. Since I want all the Buckets to be encrypted, I can re-use the same `module` structure I defined for all of them.

   - [/ecs_definition](./infrastructure/ecs_defintion) <br />
   JSON templates defining the [ECS task definition](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task_definitions.html). This template is populated by the [ecs_defintion.tf](./infrastructure/compositions/media_processing/ecs_definition.tf) Terraform template file.

   - [/policies](./infrastructure/policies) <br />
   All the policies used by the different components. These policies are templated using the same technique as the one used in `ecs_definition` module.

   - [/resources](./infrastructure/resources) <br />
   Terraform `resources` logically grouped together and called from the [./composition](infrastructure/compositions/media_processing/ecs_definition.tf) part. For exanple, a [S3 Bucket](infrastructure/resources/storage/s3/main.tf) is being defined as a group of `aws_s3_bucket`, `aws_s3_bucket_policy` and a `aws_s3_bucket_public_access_block` Terraform resource.


### How to deploy
#### Terraform backend
- `cd infrastructure/compositions/terraform_backend`
- Comment the S3 part of the [`providers.tf`](./infrastructure/compositions/terraform_backend/providers.tf) file from [`terraform_backend`](./infrastructure/compositions/terraform_backend):
```
terraform {
  required_version = ">= 0.12"
//  backend "s3" {
//  }
}
```
- `terraform init --backend-config=backend.config`
- `terraform plan`
- `terraform apply`. Optionally `terraform apply --auto-approve`
- Uncomment the S3 part
```
terraform {
  required_version = ">= 0.12"
  backend "s3" {
  }
}
```
- `terraform init --backend-config=backend.config` and type yes to copy the local state into the deployed remote state Bucket.
- Remove any `.tfstate` or `.tfstate.backup` file from the current dir.

#### Transcribe architecture
- `cd infrastructure/compositions/networking`
- `terraform init --backend-config=backend.config`
- `terraform plan`
- `terraform apply`. Optionally `terraform apply --auto-approve`
- Apply same command for `infrastructure/compositions/buckets` and `infrastructure/compositions/media_processing`
- Build and upload to ECR the Docker image used by the ECS task: <br />
With [fish](https://fishshell.com/) shell:
```bash
eval (aws ecr get-login --no-include-email --region <region>)
docker build -t ecr_media_processing .
docker tag ecr_media_processing:latest <account_id>.dkr.ecr.<region>.amazonaws.com/ecr_media_processing:latest
docker push <account_id>.dkr.ecr.<region>.amazonaws.com/ecr_media_processing:latest
```

### Machine Learning Model model accuracy
> [Amazon Transcribe uses a deep learning process called automatic speech recognition (ASR) to convert speech to text quickly and accurately](https://aws.amazon.com/transcribe/).

However, for some very close pronunciation cases, the model could be not accurate enough (although constantly improving). <br />
In the F.R.I.E.N.D.S extract I used as a test, Phoebe says:

> We went to a self-defense class

Which is translated by

> Way went to a self-defense class

![transcribe_error](./readme_assets/transcribe_error.png)
However annoying, this can be easily fixed by editing the resulting `.srt` file with a simple text editor.

### Problem encoutered and solution found
- All-in with Lambda <br />
My plan was to used only Lambdas function to do everything. I have been quickly limited because of the following reasons:
   - I needed to locally download the inout video to extract the sound from it. The `/tmp` storage is limited to [512MB](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html).
   - There was a risk of a too-long processing-time, which means the Lambda could have timed-out.
Because of these limitations, I decided to go for an ECS task running on Fargate.

- AWS Transcribe tmp file <br />
Transcribe creates a `.write_access_check_file.temp` at the root of the Bucket in which its end-result will be uploaded. This means that the `parse_transcribe_result` Lambda will be triggered by the creation of this file and will try to parse it, resulting in an error (since the Lambda expects a `.json` file, resulting from the Transcribe Job). <br />
The solution was to trigger this Lambda when a file was uploaded to the root of the Bucket *AND* that this file ends with `.json` (using the `suffix` feature).

- Transcribe and key path <br />
My initial plan was to only use one Bucket for everything. <br />
However Transcribe does not allow to specify a key path to use to upload its end-result (otherwise I would have used the already deployed `app_bucket`, and upload the final result under something like `/results`). Only a Bucket can be specified in The Transcribe job. I could have used the `app_bucket` and uploads the results at its roots, but I think this breaks the logic of having dir-like structure in this Bucket. <br />
The solution I choose was to create another Bucket (`transcribe_result_bucket`) to hold the end-result of the Transcribe job.

### Notes
- ECS on Fargate is suitable for this use-case because:
   - I do not need to manage the under-lying instances
   - I have [10GB for Docker layer, and additional 4GB for volume mounts](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-storage.html), which is enough to download most of the input vide file locally.
- The Lambda functions works inside a Private subnets and uses VPC endpoints to reach the different services.
- Same for the ECS Cluster, which uses a NAT Gateway instead to pull the Docker container from ECR.
- If you want to test the solution by yourself, I added the [`video.mp4`](./assets/video.mp4) which you can use as an input.
- The result from the Transcribe job can be found under [`tmp_transcribe_result.json`](./assets/tmp_transcribe_result.json).
- The parsed final result can be found under [`result.srt`](./assets/result.srt).

### Possible improvements
- Sharding with Kinesis.
- Have a frontend.

These solutions might be implemented in the future in a private repo.