output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_log_group.name
}

output "vpc_id" {
  value = aws_vpc.steve_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

