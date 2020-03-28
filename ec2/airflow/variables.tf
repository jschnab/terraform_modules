variable "launch_config_prefix" {
  description = "prerix for the Airflow instance launch configuration"
  type        = string
  default     = "airflo"
}

variable "instance_name" {
  description = "name of the Airflow instance"
  type        = string
}

variable "ec2_key_pair" {
  description = "key pair to SSH into the Airflow instance"
  type        = string
}

variable "state_bucket" {
  description = "name of the S3 bucket where remote state is stored"
  type        = string
}

variable "region" {
  description = "AWS region where the infrastructure is built"
  type        = string
}

variable "db_remote_state_key" {
  description = "S3 key where the remote state of the RDS database is stored"
  type        = string
}

variable "iam_remote_state_key" {
  description = "S3 key where the remote state of the IAM resources is stored"
  type        = string
}

variable "vpc_remote_state_key" {
  description = "S3 key where the remote state of the network resources is stored"
  type        = string
}

variable "security_groups_remote_state_key" {
  description = "S3 key where the remote state of security groups is stored"
  type        = string
}

variable "metadata_db_remote_state_key" {
  description = "S3 key where the remote state of the metadata database is stored"
  type        = string
}

variable "image_id" {
  description = "AMI to use for the Airflow instance"
  type        = string
  default     = "ami-0b69ea66ff7391e80"
}

variable "instance_type" {
  description = "type of the Airflow instance"
  type        = string
  default     = "t2.micro"
}

variable "custom_tags" {
  description = "tags for the Airflow instance"
  type        = map(string)
  default     = {}
}

variable "s3_bucket" {
  description = "S3 bucket where data is stored"
  type        = string
}

variable "urls_s3_key" {
  description = "S3 key where to store the file containing the list of urls to scrape"
  type        = string
}

variable "user_agent" {
  description = "user agent to use for web scraping"
  type        = string
}

variable "max_retries" {
  description = "maximum number of retries if web scraping fails"
  type        = number
}

variable "backoff_factor" {
  description = "backoff factor value for web scraping"
  type        = number
}

variable "retry_on" {
  description = "comma-separated series of HTTP code to retry scraping on"
  type        = string
}

variable "timeout" {
  description = "timeout value (seconds) for web scraping"
  type        = number
}

variable "db_name" {
  description = "name of the database to store data in the RDS instance"
  type        = string
}

variable "db_table" {
  description = "name of the table to store data in the RDS instance"
  type        = string
}

variable "db_username" {
  description = "username to access the RDS instance"
  type        = string
}

variable "db_password" {
  description = "password to access the RDS instance"
  type        = string
}

variable "meta_db_password" {
  description = "password to access the Airflow metadata database"
  type        = string
}

variable "remote_log_folder" {
  description = "name of the S3 bucket where Airflow logs are stored"
  type        = string
}
