variable "aws_profile" {
  description = "AWS profile to use to build the infrastructure"
  type        = string
}

variable "region" {
  description = "AWS region where infrastructure is build"
  type        = string
}

variable "db_name" {
  description = "name of the database in the instance"
  type        = string
}

variable "db_engine" {
  description = "engine of the RDS database (default to Postgres)"
  type        = string
  default     = "postgres"
}

variable "db_instance_class" {
  description = "instance class for the RDS database (default to t2.micro)"
  type        = string
  default     = "db.t2.micro"
}

variable "db_storage" {
  description = "size of the allocated storage for the RDS database (GB)"
  type        = number
  default     = 5
}

variable "db_username" {
  description = "username for Postgres database"
  type        = string
}

variable "db_password" {
  description = "password for Postgres database"
  type        = string
}

variable "state_bucket" {
  description = "name of the S3 bucket where remote state is stored"
  type        = string
}

variable "vpc_remote_state_key" {
  description = "S3 object key where Terraform remote state for network resources is stored"
  type        = string
}

variable "security_groups_remote_state_key" {
  description = "S3 object key where Terraform remote state for security groups is stored"
  type        = string
}

variable "subnet_group_name" {
  description = "name of the subnet group of the RDS instance"
  type        = string
}
