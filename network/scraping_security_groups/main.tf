resource "aws_security_group" "sg_ec2" {
  name   = "${var.instance_name}-security-group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "airflow_http_access" {
  security_group_id = aws_security_group.sg_ec2.id
  type              = "ingress"
  from_port         = var.airflow_webserver_port
  to_port           = var.airflow_webserver_port
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
}

resource "aws_security_group_rule" "airflow_ssh_access" {
  security_group_id = aws_security_group.sg_ec2.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
}

resource "aws_security_group_rule" "airflow_outbound" {
  security_group_id = aws_security_group.sg_ec2.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "sg_database" {
  name   = "database-security-group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "airflow_access" {
  security_group_id        = aws_security_group.sg_database.id
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_ec2.id
}

resource "aws_security_group" "sg_webserver" {
  name   = "webserver-security-group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "webserver_http_access" {
  security_group_id        = aws_security_group.sg_webserver.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_load_balancer.id
}

resource "aws_security_group_rule" "webserver_ssh_access" {
  security_group_id = aws_security_group.sg_webserver.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
}

resource "aws_security_group_rule" "webserver_outbound" {
  security_group_id = aws_security_group.sg_webserver.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "sg_load_balancer" {
  name   = "load-balancer-security-group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "lb_http_access" {
  security_group_id = aws_security_group.sg_load_balancer.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
}

resource "aws_security_group_rule" "lb_https_access" {
  security_group_id = aws_security_group.sg_load_balancer.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
}

resource "aws_security_group_rule" "lb_outbound" {
  security_group_id = aws_security_group.sg_load_balancer.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.vpc_remote_state_key
    region = var.region
  }
}
