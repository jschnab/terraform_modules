output "webserver_profile" {
  description = "IAM profile for the webserver instances"
  value       = aws_iam_instance_profile.webserver_profile.name
}
