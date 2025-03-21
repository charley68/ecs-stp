resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = var.log_group_name
  retention_in_days = 7

  tags = {
    Name = "steve-ecs-log-group"
  }
}

