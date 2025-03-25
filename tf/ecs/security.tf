resource "aws_security_group" "sg_lb" {
  name        = "lb-sg"
  description = "Allow public HTTP/HTTPS"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_security_group" "sg_ecs" {
  name        = "ecs-sg"
  description = "Allow only traffic from LB"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  ingress {
    description     = "Allow traffic from Load Balancer SG"
    from_port       = 5000                # or 8080, 3000, etc — your app port
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

