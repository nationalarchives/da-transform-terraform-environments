provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_role
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
  }
}
