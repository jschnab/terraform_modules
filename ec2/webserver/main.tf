resource "aws_launch_configuration" "web_server" {
  name_prefix          = var.launch_conf_prefix
  image_id             = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = data.terraform_remote_state.iam.outputs.webserver_profile
  user_data            = var.user_data

  security_groups = [
    data.terraform_remote_state.security_groups.outputs.webserver_security_group_id
  ]

  root_block_device = {
    volume_type  = var.block_device_type
    volumne_size = var.block_device_volume
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.state_iam_key
    region = var.region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.state_security_groups_key
    region = var.region
  }
}
