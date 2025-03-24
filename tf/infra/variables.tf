variable "region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet1_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet2_cidr" {
  default = "10.0.4.0/24"
}

variable "log_group_name" {
  default = "/ecs/steve-ecs-task"
}

