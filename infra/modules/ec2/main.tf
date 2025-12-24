resource "aws_instance" "app_server" {
  count         = length(var.private_subnet_ids)
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"
  subnet_id = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [ var.app_sg_id ]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello from user-data" > /var/www/html/index.html
                EOF

  tags = {
    Name = "AppServer-${count.index + 1}"
  }
}

resource "aws_lb_target_group_attachment" "attach_app" {
  count     = 2
  target_group_arn = var.lb_target_group_arn
  target_id = aws_instance.app_server[count.index].id
  port      = 80
}
