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
      ecr_url = var.ecr_url
      db_host = var.db_host
      db_user = var.db_user
      db_password = var.db_password
      db_name = var.db_name
    })
  )
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 0
  min_size            = 0
  max_size            = 0
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

# resource "aws_instance" "app_server" {
#   count         = length(var.private_subnet_ids)
#   ami           = "ami-00d8fc944fb171e29"
#   instance_type = "t3.micro"
#   subnet_id = var.private_subnet_ids[count.index]
#   vpc_security_group_ids = [ var.app_sg_id ]

#   user_data = <<-EOF
#                 #!/bin/bash
#                 echo "Hello from user-data" > /var/www/html/index.html
#                 EOF

#   tags = {
#     Name = "AppServer-${count.index + 1}"
#   }
# }

# resource "aws_lb_target_group_attachment" "attach_app" {
#   count     = 2
#   target_group_arn = var.lb_target_group_arn
#   target_id = aws_instance.app_server[count.index].id
#   port      = 80
# }
