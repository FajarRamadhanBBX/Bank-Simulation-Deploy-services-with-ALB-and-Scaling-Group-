resource "aws_security_group" "alb" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ip_internet]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.ip_internet]
    }

    tags = {
        Name = "alb_sg"
    }
}

resource "aws_security_group" "app" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [aws_security_group.alb.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.ip_internet]
    }

    tags = {
      Name = "app_sg"
    }
}

resource "aws_security_group" "db" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [aws_security_group.app.id]
    }

    tags = {
      Name = "db_sg"
    }
}
