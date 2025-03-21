resource "aws_ecs_cluster" "main" {
  name = "steveECSCluster"

  tags = {
    Name = "steveECSCluster"
    Environment = "dev"
  }
}

