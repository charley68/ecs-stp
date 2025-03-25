
# Create ALB in public subnets
resource "aws_lb" "app_alb" {
  name               = "steve-app-alb"
  load_balancer_type = "application"
  subnets            = [data.terraform_remote_state.infra.outputs.public_subnet1_id, data.terraform_remote_state.infra.outputs.public_subnet2_id]
  security_groups    = [aws_security_group.sg_lb.id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "steve-app-alb"
  }
}

# Create ALB Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "steve-app-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "steve-app-tg"
  }
}

# ALB Listener on Port 80
resource "aws_lb_listener" "app_http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


