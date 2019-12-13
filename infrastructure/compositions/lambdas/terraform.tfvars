# General attributes
region = "eu-central-1"

# General Lambdas  attributes
runtime             = "python3.7"
publish             = false
memory_size         = 256
timeout             = 5
lambda_trust_policy = "../../../policies/lambda_trust_policy.json"

# Specific Lambdas attributes
lambda_extract_sound_input_path  = "../../../lambdas/extract_sound.py"
lambda_extract_sound_output_path = "../../../lambdas/extract_sound.py"
lambda_extract_sound_s3_key      = "lambdas/extract_sound.py"
lambda_extract_sound_name        = "extract_sound"
lambda_extract_sound_handler     = "../../../lambdas/extract_sound.py"

