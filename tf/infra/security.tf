resource "aws_security_group" "ecs_sg" {
  name        = "steve-ecs-stp-sg"
  description = "Allow port 5000 for ECS Flask"
  vpc_id      = aws_vpc.steve_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "steve-ecs-stp-sg"
  }
}

