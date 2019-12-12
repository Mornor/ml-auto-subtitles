- Use S3 to trigger a job to ECS or something AWS native.
 -> Will also solve the issue of waiting for the mp3 file to be uploaded to S3 before starting transcribe job.
 -> Create the terraform code to do so.
- Delete old mp3 file from S3 once transcribe job is done.
- Upload the Video to S3 and use AWS native stuff to extract sound from it.
- Add some SQS for buffering/scaling.
- Put AWS lamnbdas in VPC to avoid communication over internet (and add S3 endpoint in VPC).

[TODO]
- Add permissions to S3 Bucket so that Lambda can read/write to/from it.