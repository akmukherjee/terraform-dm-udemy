# ---- loadbalancing/main.tf

resource "aws_alb" "mtc-alb" {
  name            = "mtc-loadbalancer"
  subnets         = var.public_subnets
  security_groups = var.public_sg
  idle_timeout    = 400

}

resource "aws_alb_target_group" "mtc-alb-tg" {
  name     = "mtc-tg-${substr(uuid(), 0, 4)}"
  port     = var.tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes = [name]
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_thredhold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }

}

resource "aws_alb_listener" "mtc-alb-listener" {
  load_balancer_arn = aws_alb.mtc-alb.arn
  port = var.listener_port
  protocol = var.listener_protocol
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.mtc-alb-tg.arn
  }
  
}