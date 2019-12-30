# General attributes
region = "eu-central-1"

# General Lambdas  attributes
runtime             = "python3.7"
publish             = false
memory_size         = 256
timeout             = 5
lambda_trust_policy = "../../policies/lambda_trust_policy.json"

# Specific Lambdas attributes
lambda_extract_sound_input_path  = "../../../code/lambdas/extract_sound/extract_sound.py"
lambda_extract_sound_output_path = "../../../code/lambdas/extract_sound/extract_sound.zip"
lambda_extract_sound_policy_path = "../../policies/lambda_access_app_bucket_policy.json.tpl"
lambda_extract_sound_policy_name = "policy_lambda_extract_sound"
lambda_extract_sound_s3_key      = "extract_sound/extract_sound.zip"
lambda_extract_sound_name        = "extract_sound"
lambda_extract_sound_handler     = "extract_sound.handler"
lambda_extract_sound_description = "Extract sound from the video file uploaded to S3"

