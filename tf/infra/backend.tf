terraform {
  backend "s3" {
    bucket         = "steve-terraform-s3-state"
    key            = "ecs/infra/terraform.tfstate"
    region         = "eu-west-2"
    #dynamodb_table = "my-tf-lock-table"  # For state locking (optional but recommended)
    encrypt        = true
  }
}

