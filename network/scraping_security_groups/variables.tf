variable "instance_name" {
  description = "name of the EC2 instance"
  type        = string
}

variable "airflow_webserver_port" {
  description = "port to connect to the Airflow web UI"
  type        = number
}

variable "db_port" {
  description = "port to connect to the database"
  type        = string
}

variable "my_ip" {
  description = "IP from where access to the instance is allowed"
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket where Terraform state is stored"
  type        = string
}

variable "region" {
  description = "AWS region where to build the infrastructure"
  type        = string
}

variable "vpc_remote_state_key" {
  description = "S3 object key where Terraform remote state for network resources is stored"
  type        = string
}
