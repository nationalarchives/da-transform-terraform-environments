provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_role
  }
}

terraform {
  backend "s3" {
  }
}
