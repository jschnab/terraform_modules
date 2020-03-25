variable "launch_config_prefix" {
  description = "Create a unique name beginning with the prefix"
  type        = string
  default     = "dashb-"
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

variable "state_vpc_key" {
  description = "Key of the S3 object storing remote state for VPC"
  type        = string
}

variable "region" {
  description = "Region where the infrastructure is deployed"
  type        = string
}

variable "asg_name" {
  description = "Name of the autoscaling group"
  type        = string
  default     = "finance-scraping-webserver-asg"
}

variable "asg_desired_capacity" {
  description = "The number of instances which should be running"
  type        = number
  default     = 1
}

variable "asg_min_size" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
  default     = 5
}

variable "custom_tags" {
  description = "Tags for the autoscaling group instances"
  type        = map(string)
  default     = {}
}

variable "lb_name_prefix" {
  description = "Name prefix of the load balancer"
  type        = string
  default     = "fin-lb"
}

variable "lb_idle_timeout" {
  description = "Time in seconds the connection is allowed to be idle"
  type        = number
  default     = 30
}

variable "health_check_interval" {
  description = "Seconds between health checks of an individual target"
  type        = number
  default     = 15
}

variable "health_check_timeout" {
  description = "Seconds after which a health check fails if no response"
  type        = number
  default     = 6
}

variable "healthy_threshold" {
  description = "Number of consecutive successful checks before target labeled healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive unsuccessful checks before target labeled unhealthy"
  type        = number
  default     = 3
}

variable "domain_name" {
  description = "Name of the web domain to use for the server"
  type        = string
}

variable "scale_out_adjustment" {
  description = "Number of instances by which to scale out"
  type        = number
  default     = 1
}

variable "scale_in_adjustment" {
  description = "Number of instances by which to scale in"
  type        = number
  default     = -1
}

variable "scale_cooldown" {
  description = "Number of seconds before next scaling can start"
  type        = number
  default     = 300
}

variable "high_cpu_eval_periods" {
  description = "Number of periods over which CPU is compared to high threshold"
  type        = number
  default     = 1
}

variable "low_cpu_eval_periods" {
  description = "Number of periods over which CPU is compared to low threshold"
  type        = number
  default     = 3
}

variable "cpu_period" {
  description = "Number of seconds over which statistic is applied to CPU utilization"
  type        = number
  default     = 300
}

variable "cpu_statistic" {
  description = "Statistic to apply to CPU utilization metric"
  type        = string
  default     = "Average"
}

variable "high_cpu_threshold" {
  description = "Threshold over which CPU utilization requires scale out"
  type        = number
  default     = 80
}

variable "low_cpu_threshold" {
  description = "Threshold under which CPU utilization requires scale in"
  type        = number
  default     = 20
}

variable "cpu_unit" {
  description = "Unit of measure of CPU utilization"
  type        = string
  default     = "Percent"
}
