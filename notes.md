[TODO]
- Make sure Lambda connectivity does not goes through the internet
- May be create a SG to run the ECS task (right now, it uses the default SG of the VPC).
- Sharding could be very effective. Lambda only uses chnunk of 5mb video.
- Parametrize Lambda as much as possible
- Find a way to re-trigger lambda deployment when code changed
- Check what's the difference between ecs_task_role and ecs_task_execution_role, and which one I need.

[DONE]
- In the s3-ec1-lambdas-bucket, there is no need to create folders. Remove them.
- In the s3-ec1-app-bucket, no need for an outputs/ key.
- Delete SQS message once sound is extracted (done by the Lambda once the message has been processed)
- Check timeout of Lambda. Right now, it's 5 secs, might be too low. Increased to 5mins.
- Check what is the max size of file I can locally download with ECS (need EFS?) -> 10GB for Docker layer, and additional 4GB for volume mounts.
- Handle failure on the ECS container and all the Lambdas (no SQS message etc ...)
- In the trigger_transcribe_job lambda, we can automatically get the MediaFormat from the key (.split('.')[0]) -> .mp3, instead of giving it a variable.
- Delete old mp3 file from S3 once transcribe job is done.
- How to retrieve the srt file corresponding to the input video if several input at the same time? -> Pass the input name along the chain.
- Put the Lambdas inside VPC and create interface endpoints, so that communications does not go through Internet.

[Problem]
- Not possible to extract sound w/ lambda because Numpy cannot be added to a Python package.
- ECS Cluster, and how I implemented it.
- A Lambda is used to trigger the ECS task. The ECS task was supposed to get the message from the SQS, but that does not work because the message is "in-flight" (being processed by the lambda). Solution is to send env variable read by the lambda from the SQS to the ECS.
- When a Lambda is triggered when a message is received in the SQS queue, we need to parse the event, and not try to use boto3 to fetch the message. Everything is in event['Records'][0].
- Transcribe creates a temp file on the bucket each time a Transcribe job is performed. That triggger the parse lambda w/ the wrong file. Solution was to add a suffix (.json) to the Bucket notification.

[Idea]
- In another branch, use the ECS task to do everything instead of all the lambdas. Explain in the readme why I did not.