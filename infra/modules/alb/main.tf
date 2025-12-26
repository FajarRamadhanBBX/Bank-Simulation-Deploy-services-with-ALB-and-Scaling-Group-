resource "aws_lb" "main" {
  name = "app-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.alb_sg_id]
  subnets = var.public_subnet_ids
}

resource "aws_lb_target_group" "app_tg" {
  name = "app-tg"
  vpc_id = var.vpc_id
  port = 80
  protocol = "HTTP"

  health_check {
    path = "/ping"
    healthy_threshold = 2     # jumlah respon sehat berturut-turut
    unhealthy_threshold = 2     # jumlah respon tidak sehat berturut-turut
    timeout = 5     # waktu tunggu respon
    interval = 30    # frekuensi pengecekan
    matcher = "200" # kode status HTTP yang dianggap sehat
  }
}

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.main.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}