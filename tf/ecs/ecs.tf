resource "aws_ecs_service" "app_service" {
  name            = "steve-app-service"
  cluster         = data.terraform_remote_state.infra.outputs.ecs_cluster_name
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [data.terraform_remote_state.infra.outputs.private_subnet1_id, data.terraform_remote_state.infra.outputs.private_subnet2_id ]
    security_groups  = [data.terraform_remote_state.infra.outputs.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "steve-stp-flask"
    container_port   = 5000
  }

  depends_on = [aws_ecs_task_definition.app]
}

