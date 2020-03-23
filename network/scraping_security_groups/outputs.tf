output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.sg_database.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 instance security group"
  value       = aws_security_group.sg_ec2.id
}

output "webserver_security_group_id" {
  description = "ID of the webserver security group"
  value       = aws_security_group.sg_webserver.id
}

output "load_balancer_security_group_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.sg_load_balancer.id
}
