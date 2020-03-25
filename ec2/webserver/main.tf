resource "aws_launch_configuration" "webserver" {
  name_prefix          = var.launch_config_prefix
  image_id             = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = data.terraform_remote_state.iam.outputs.webserver_profile
  user_data            = var.user_data

  security_groups = [
    data.terraform_remote_state.security_groups.outputs.webserver_security_group_id
  ]

  root_block_device {
    volume_type = var.block_device_type
    volume_size = var.block_device_size
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver" {
  name                 = var.asg_name
  launch_configuration = aws_launch_configuration.webserver.name

  vpc_zone_identifier = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_2_id
  ]

  target_group_arns = [aws_lb_target_group.webserver.arn]
  desired_capacity  = var.asg_desired_capacity
  min_size          = var.asg_min_size
  max_size          = var.asg_max_size

  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "scale_out_high_cpu" {
  name                   = "${var.asg_name}-scale-out-high-cpu"
  scaling_adjustment     = var.scale_out_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_cooldown
  autoscaling_group_name = aws_autoscaling_group.webserver.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "${var.asg_name}-high-cpu"
  alarm_description   = "Scale out when CPU is too high"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.webserver.name }
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.high_cpu_eval_periods
  period              = var.cpu_period
  statistic           = var.cpu_statistic
  threshold           = var.high_cpu_threshold
  unit                = var.cpu_unit
  alarm_actions       = [aws_autoscaling_policy.scale_out_high_cpu.arn]
}

resource "aws_autoscaling_policy" "scale_in_low_cpu" {
  name                   = "${var.asg_name}-scale-in-low-cpu"
  scaling_adjustment     = var.scale_in_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_cooldown
  autoscaling_group_name = aws_autoscaling_group.webserver.name
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "${var.asg_name}-low-cpu"
  alarm_description   = "Scale in when CPU is low"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.webserver.name }
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cpu_eval_periods
  period              = var.cpu_period
  statistic           = var.cpu_statistic
  threshold           = var.low_cpu_threshold
  unit                = var.cpu_unit
  alarm_actions       = [aws_autoscaling_policy.scale_in_low_cpu.arn]
}

resource "aws_lb" "web_lb" {
  name_prefix = var.lb_name_prefix
  security_groups = [
    data.terraform_remote_state.security_groups.outputs.load_balancer_security_group_id
  ]
  subnets = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_2_id
  ]
  idle_timeout = var.lb_idle_timeout
}

resource "aws_lb_target_group" "webserver" {
  name     = var.lb_name_prefix
  port     = "80"
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/elb-check"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.valid.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}


data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.state_iam_key
    region = var.region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.state_vpc_key
    region = var.region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = var.state_security_groups_key
    region = var.region
  }
}
