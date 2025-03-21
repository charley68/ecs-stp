data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "steve-terraform-s3-state"
    key    = "ecs/infra/terraform.tfstate"
    region = "eu-west-2"
  }
}



resource "aws_ecs_task_definition" "app" {
  family                   = "steve-flask-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.terraform_remote_state.infra.outputs.ecs_execution_role_arn

  #task_role_arn            = aws_iam_role.ecs_execution_role.arn  # optional; or define a separate one

  container_definitions = jsonencode([
    {
      name      = "steve-stp-flask"
      image     = "717279690473.dkr.ecr.eu-west-2.amazonaws.com/stp:latest"  # ECR Repo
      essential = true
      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DYNAMODB_TABLE"
          value = "ECS_Requests"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = data.terraform_remote_state.infra.outputs.log_group_name
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

