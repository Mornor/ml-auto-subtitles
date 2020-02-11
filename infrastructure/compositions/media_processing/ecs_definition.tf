# Current account ID
data "aws_caller_identity" "current" {}

# ECS task definition
data "template_file" "ecs_task_definition" {
  template = file(var.ecs_definition_path)
  vars = {
    region          = var.region
    container_name  = "extract_sound_from_video"
    container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/ecr_media_processing"
    sqs_queue_url   = module.sqs_inputs.url
  }
}