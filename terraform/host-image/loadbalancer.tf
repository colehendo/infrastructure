resource "aws_lb" "main" {
  name                       = "${var.project_name}-ecs-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ecs_sg.id]
  subnets                    = [aws_subnet.public_first_az.id, aws_subnet.public_second_az.id]
  idle_timeout               = 30
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ecs_tg" {
  name     = "${var.project_name}-ecs-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/status"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 10
    matcher             = "200"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    type             = "forward"
  }
}