## Automatic Subtitles Generation and synchronization with AWS Transcribe

### Intro
[AWS Transcribe](https://aws.amazon.com/transcribe/) allows to automaticaly convert speech to text using their own Machine Learning trained model. <br/>
Using it, I created a project to generate subtitles from a given video as an input file. <br />
This repo contains the Terraform templates in order to deploy the solution in AWS, as well as the code used for the Lambdas and the code used by the ECS from ECR.

### Basic idea
1. Put a video file as input in a S3 folder.
2. Get the result as a .srt file

### Repository explanation

### Architecture
#### Schema
Below is the architecture deployed by the Terraform template.
#### Explanation


### Problem encoutered and solution found