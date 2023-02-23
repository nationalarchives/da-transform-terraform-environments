provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.root
    # external_id = var.assume_role_external_id
  }
}

provider "aws" {
  alias  = "nonprod"
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.nonprod
    # external_id = var.assume_role_external_id
  }
}

provider "aws" {
  alias  = "prod"
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.prod
    # external_id = var.assume_role_external_id
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
