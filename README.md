## Automatic Subtitles Generation and Synchronization with AWS Transcribe

### Intro
[AWS Transcribe](https://aws.amazon.com/transcribe/) allows to automaticaly convert speech to text using their own Machine Learning trained model. <br />
Using it, I created a project to generate and synchronize subtitles from a given video as an input file. <br />
This repo contains the Terraform templates in order to deploy the solution in AWS, as well as the code used for the Lambdas and the code used by the ECS from ECR.

### Basic idea
1. Put a video file as input in a S3 folder.
2. Get the result as a .srt file

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

### Architecture
#### Schema
Below is the architecture deployed by the Terraform template.
![architecture](./readme_assets/aws_subtitles_infrastructure.png)

#### Workflow

### Machine Learning Model model accuracy
Way went -> We went

### Problem encoutered and solution found

### Notes and future improvements
Reference the `notes.md` file. Sharding (not sure if I should mention). Frontend.

- First list item
   - First nested list item
     - Second nested list item