terraform {
  backend "s3" {
    bucket         = "steve-terraform-s3-state"
    key            = "ecs/service/terraform.tfstate"
    region = "eu-west-2"
  }
}
