output "state_bucket_arn" {
  value = "${aws_s3_bucket.terraform_state.arn}"
  description = "ARN of the S3 bucket"
}

output "data_bucket_arn" {
  value = "${aws_s3_bucket.finance_scraping.arn}"
  description = "ARN of bucket storing data"
}

output "airflow_logs_bucket_arn" {
	value = "${aws_s3_bucket.airflow_logs.arn}"
	description = "ARN of the bucket storing Airflow logs"
}
