resource "aws_security_group" "sg_ec2" {
  name = "${var.instance_name}-security-group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}

resource "aws_security_group_rule" "access_to_ec2_webserver" {
	security_group_id = aws_security_group.sg_ec2.id
  type = "ingress"
  from_port = var.web_port
  to_port = var.web_port
  protocol = "tcp"
  cidr_blocks = [var.my_ip] 
}

resource "aws_security_group_rule" "ssh_access" {
	security_group_id = aws_security_group.sg_ec2.id
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [var.my_ip]
}

resource "aws_security_group_rule" "outbound" {
  security_group_id = aws_security_group.sg_ec2.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "sg_database" {
	name = "database-security-group"
	vpc_id = data.terraform_state.network.outputs.vpc_id
}

resource "aws_security_group_rule" "airflow_access" {
	security_group_id = aws_security_group.sg_database.id
	type = "ingress"
	from_port = var.db_port
	to_port = var.db_port
	protocol = "tcp"
	source_security_group_id = aws_security_group.sg_ec2.id
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key = var.network_remote_state_key
    region = var.region
  }
}
