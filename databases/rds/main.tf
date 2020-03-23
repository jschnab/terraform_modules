resource "aws_db_instance" "rds_db" {
  # only alphanumeric characters and hyphens are allowed for identifier_prefix
  identifier_prefix    = replace(var.db_name, "/[^a-zA-Z0-9]/", "-")
  engine               = var.db_engine
  allocated_storage    = var.db_storage
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.private_subnets_group.id
  vpc_security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.database_security_group_id
  ]
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "private_subnets_group" {
  description = "Group of private subnets to place the RDS instance in"
  name        = var.subnet_group_name
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.private_subnet_1_id,
    data.terraform_remote_state.vpc.outputs.private_subnet_2_id
  ]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.vpc_remote_state_key
    region = var.region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.security_groups_remote_state_key
    region = var.region
  }
}
