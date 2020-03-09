module "default_sg" {
  source = "../../resources/sg/default"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}