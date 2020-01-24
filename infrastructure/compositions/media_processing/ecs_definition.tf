# ECS task definition
data "template_file" "ecs_task_definition" {
  template = file(var.ecs_definition_path)
  vars = {
    region = var.region
    container_name = "extract_sound_from_video"
    container_image = "453119308637.dkr.ecr.eu-central-1.amazonaws.com/ecr_media_processing"
    sqs_queue_url = = module.sqs_inputs.id
  }
}