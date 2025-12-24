resource "aws_lb" "main" {
    internal = false
    load_balancer_type = "application"
    security_groups = [ var.alb_sg_id ]
    subnets = var.public_subnet_ids
}

resource "aws_lb_target_group" "app_tg" {
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/"
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 5
        interval = 30
        matcher = "200"
    }
}