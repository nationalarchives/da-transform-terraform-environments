provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_role
    external_id = "zaizi-tre-f16acc04-50f6-4a71-895f-554eb89c8704"
  }
  default_tags {
    tags = {
      Environment     = var.environment_name
      Owner           = "digital-archiving"
      Terraform       = true
      TerraformSource = "https://github.com/nationalarchives/da-transform-terraform-environments"
      CostCentre      = "56"
      Role            = "prvt"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
  }
}
