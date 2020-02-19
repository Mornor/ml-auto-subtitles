- Use S3 to trigger a job to ECS or something AWS native.
 -> Will also solve the issue of waiting for the mp3 file to be uploaded to S3 before starting transcribe job.
 -> Create the terraform code to do so.
- Delete old mp3 file from S3 once transcribe job is done.
- Upload the Video to S3 and use AWS native stuff to extract sound from it.
- Add some SQS for buffering/scaling.
- Put AWS lamnbdas in VPC to avoid communication over internet (and add S3 endpoint in VPC).
- Check if using locals instead of vars makes more sense.

[TODO]
- Add permissions to S3 Bucket so that Lambda can read/write to/from it.
- Check what's the difference between ecs_task_role and ecs_task_execution_role, and which one I need.
- Handle failure on the ECS container (no SQS message etc ...)
- Delete SQS message once sound is extracted.
- May be create a SG to run the ECS task (right now, it uses the default SG of the VPC).
- Put the Lambdas inside VPC and create interface endpoints, so that communications does not go through Internet.
- In the s3-ec1-lambdas-bucket, there is no need to create folders. Remove them.
- Check timeout of Lambda. Right now, it's 5 secs, might be too low.
- If timeout is more than 5sec, sometimes (to be confirmed), the Lambda triggers more than 1 task. Why?

[Problem]
- Not possible to extract sound w/ lambda because Numpy cannot be added to a Python package.
- ECS Cluster, and how I implemented it.
- A Lambda is used to trigger the ECS task. The ECS task was supposed to get the message from the SQS, but thgat does not work because the message is "in-flight" (being processed by the lambda). Solution is to send env variable read by the lambda from the SQS to the ECS.
- When a Lambda is triggered when a message is received in the SQS queue, we need to parse the event, and not try to use boto3 to fetch the message. Everything is in event['Records'][0].

[Idea]
- In another branch, use the ECS task to do everything instead of all the lambdas. Explain in the readme why I did not.