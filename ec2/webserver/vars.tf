variable "launch_config_prefix" {
  description = "Create a unique name beginning with the prefix"
  type        = string
  default     = "web-server-conf-"
}

variable "image_id" {
  description = "Image ID to launch"
  type        = string
  default     = "ami-0b69ea66ff7391e80"
}

variable "instance_type" {
  description = "Size of the instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key to connect to the instance"
  type        = string
}

variable "user_data" {
  description = "Script to run when launching the instance"
  type        = string
}

variable "block_device_type" {
  description = "Type of the EBS volume"
  type        = string
  default     = "gp2"
}

variable "block_device_size" {
  description = "Size of the volumn in GB"
  type        = number
  default     = 8
}

variable "state_bucket" {
  description = "S3 bucket where the remote state is stored"
  type        = string
}

variable "state_security_groups_key" {
  description = "Key of the S3 object storing remote state for security groups"
  type        = string
}

variable "state_iam_key" {
	description = "Key of the S3 object storing remote state for IAM"
	type        = string
}

variable "region" {
  description = "Region where the infrastructure is deployed"
  type        = string
}
