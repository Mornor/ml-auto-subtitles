## Automatic Subtitles Generation and Synchronization with AWS Transcribe

### Intro
[AWS Transcribe](https://aws.amazon.com/transcribe/) allows to automaticaly convert speech to text using their own Machine Learning trained model. <br />
Using it, I created a project to generate and synchronize subtitles from a given video as an input file. <br />
This repo contains the Terraform templates in order to deploy the solution in AWS, as well as the code used for the Lambdas and the code used by the ECS from ECR.

### Basic idea
1. Put a video file as input in a S3 folder.
2. Get the result as a .srt file

### Architecture
#### Schema
![architecture](./readme_assets/aws_subtitles_infrastructure.png)

#### Workflow
1. The user puts the input video file into the [`app_bucket`](infrastructure/compositions/buckets/main.tf) under `inputs/`.
2. This triggers the [`input_to_sqs`](./code/lambdas/input_to_sqs/main.py) Lambda which will send the key path of the input file into the [`sqs_input`](./infrastructure/compositions/media_processing/sqs.tf) Queue.
3. A message put into this queue triggers the [`trigger_ecs_task`](./code/lambdas/trigger_ecs_task/main.py) Lambda. The function will
   1. read and parse the message from the SQS Queue.
   2. trigger an ECS task and passing the values (key pahth and bucket name) fetched from the SQS to it.
4. The ECS task will download the input file into its local FS, extract the sound from it and upload the `.mp3` result under `/tmp` of the `app_bucket`.
5. Once a message is put under `tmp/` the [`trigger_transcribe_job`](./code/lambdas/trigger_transcribe_job/main.py) starts the Transcribe job and send to it the key path of the extracted sound as well as the bucket name.
6. The Transcribe job starts with the arguments given to it (key path of the `.mp3` file and the bucket name).
7. Once the Transcribe job is done, its result is uploaded into the [`transcribe_result_bucket`](infrastructure/compositions/buckets/main.tf).
8. This result needs to be parsed into a `.srt` format, which is what the [`parse_transcribe_result`](code/lambdas/parse_transcribe_result/main.py) Lambda does when triggered by a bucket notification when a file is uploaded into the root of the `transcribe_result_bucket`.
9. Finally, the parsed and synchronized `.srt` file from the uploaded input video is uploaded into the `transcribe_result_bucket` under `results/`


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
With [fish](https://fishshell.com/) shell:
```bash
eval (aws ecr get-login --no-include-email --region <region>)
docker build -t ecr_media_processing .
docker tag ecr_media_processing:latest <account_id>.dkr.ecr.<region>.amazonaws.com/ecr_media_processing:latest
docker push <account_id>.dkr.ecr.<region>.amazonaws.com/ecr_media_processing:latest
```

- [./infrastructure](./infrastructure) <br />
This directory contains all the necessary templates and resources to deploy the infrastructure on AWS.

   - [/compostions](./infrastructure/compositions) <br />
   Logical units of Terraform code. Each parts define some Terraform `modules` which call a group of Terraform `resources` defined in [./infrastructure/resources](./infrastructure/resources). For example, in `buckets` we can find the code used to deploy each S3 Buckets used by the code. Since I want all my buckets to be encrypted, I can re-use the same `module` structure I defined for all of them.

   - [/ecs_definition](./infrastructure/ecs_defintion) <br />
   JSON templates defining the [ECS task definition](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task_definitions.html). This template is populated by the [ecs_defintion.tf](./infrastructure/compositions/media_processing/ecs_definition.tf) Terraform template file.

   - [/policies](./infrastructure/policies) <br />
   All the policies used by the different components. These policies are also templated using the same technique as the one used in `ecs_definition` module.

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
- `terraform init --backend-config=backend.config` and type yes to copy the local state into the deployed remote state bucket.
- Remove any `.tfstate` or `.tfstate.backup` file from the current dir.

#### Transcribe architecture

### Machine Learning Model model accuracy
Way went -> We went

### Problem encoutered and solution found

### Notes and future improvements
Reference the `notes.md` file. Sharding (not sure if I should mention). Frontend.

- First list item
   - First nested list item
     - Second nested list item