resource "aws_launch_template" "app_lt" {
  name = "app-server-lt"
  instance_type = "t3.micro"
  image_id = "ami-00d8fc944fb171e29"
  vpc_security_group_ids = [ var.app_sg_id ]

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      db_host = var.db_host
      db_user = var.db_user
      db_password = var.db_password
      db_name = var.db_name
    })
  )
}

resource "aws_autoscaling_group" "app_asg" {
  name = "app-asg"
  desired_capacity = 1
  min_size = 0
  max_size = 1
  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [var.lb_target_group_arn]
  health_check_grace_period = 90
  health_check_type = "ELB"
  
  launch_template {
    id = aws_launch_template.app_lt.id
    version = ("$Latest")
  }
}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name = "cpu-target-tracking-policy"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}
