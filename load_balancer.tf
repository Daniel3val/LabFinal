# Balanceador de carga (ALB) interno

resource "aws_lb" "internal_alb" {
  name               = var.lb_names.internal_alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb_sg.id]
  subnets            = module.vpc.private_subnets

  tags = merge(var.tags, { Name = var.lb_names.internal_alb })
}

resource "aws_lb_target_group" "internal_tg" {
  name     = var.target_group_names.internal
  port     = var.listener_ports.https
  protocol = "HTTPS"
  vpc_id   = module.vpc.vpc_id
  
  health_check {
    enabled             = var.health_check_settings.enabled
    healthy_threshold   = var.health_check_settings.healthy_threshold
    unhealthy_threshold = var.health_check_settings.unhealthy_threshold
    interval            = var.health_check_settings.interval
    matcher            = var.health_check_settings.matcher
    path               = var.health_check_settings.path
    port               = var.health_check_settings.port
    protocol           = var.health_check_settings.protocol
    timeout            = var.health_check_settings.timeout
  }

  tags = merge(var.tags, { Name = var.target_group_names.internal })
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = var.listener_ports.https
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_tg.arn
  }
  
  tags = merge(var.tags, { Name = "listener-interno" })
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
  lb_target_group_arn    = aws_lb_target_group.internal_tg.arn
}

resource "aws_lb" "external_nlb" {
  name               = var.lb_names.external_nlb
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.nlb_sg.id]

  enable_cross_zone_load_balancing = var.enable_cross_zone_lb

  tags = merge(var.tags, { Name = var.lb_names.external_nlb })
}

resource "aws_lb_target_group" "external_nlb_tg" {
  name        = var.target_group_names.external
  port        = var.listener_ports.https
  protocol    = "TCP"
  vpc_id      = module.vpc.vpc_id
  target_type = "alb"

  health_check {
    enabled             = var.health_check_settings.enabled
    healthy_threshold   = var.health_check_settings.healthy_threshold
    unhealthy_threshold = var.health_check_settings.unhealthy_threshold
    interval            = var.health_check_settings.interval
    matcher            = var.health_check_settings.matcher
    path               = var.health_check_settings.path
    port               = var.health_check_settings.port
    protocol           = var.health_check_settings.protocol
    timeout            = var.health_check_settings.timeout
  }
}

resource "aws_lb_listener" "external_listener" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = var.listener_ports.https
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg.arn
  }

  tags = merge(var.tags, { Name = "listener-externo" })
}

resource "aws_lb_target_group_attachment" "nlb_to_alb" {
  target_group_arn = aws_lb_target_group.external_nlb_tg.arn
  target_id        = aws_lb.internal_alb.arn
  port             = var.listener_ports.https

  depends_on = [
    aws_lb.internal_alb,
    aws_lb_listener.internal_listener
  ]
}