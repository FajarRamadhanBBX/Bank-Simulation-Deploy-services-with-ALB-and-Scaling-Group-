data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"] # Canonical
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-22.04-amd64-server-*"]
    }
}

resource "aws_instance" "app_server" {
    count = 2
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"

    subnet_id = var.private_subnet_ids[count.index]
    vpc_security_group_ids = [var.app_sg_id]

    user_data = <<-EOF
                EOF
    
    tags = {
        Name = "AppServer-${count.index + 1}"
    }
}

resource "aws_lb_target_group_attachment" "attach_app" {
    count = 2
    target_group_arn = var.lb_target_group_arn
    target_id = aws_instance.app_server[count.index].id
    port = 80
}