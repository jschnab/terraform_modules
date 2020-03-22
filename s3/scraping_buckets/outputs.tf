output "state_bucket_arn" {
  value       = "${aws_s3_bucket.terraform_state.arn}"
  description = "ARN of the S3 bucket"
}

output "data_bucket_arn" {
  value       = "${aws_s3_bucket.data_bucket.arn}"
  description = "ARN of bucket storing data"
}

output "logs_bucket_arn" {
  value       = "${aws_s3_bucket.logs.arn}"
  description = "ARN of the bucket storing logs"
}
