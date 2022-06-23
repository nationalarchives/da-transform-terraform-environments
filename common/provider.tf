provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.root
  }
}

provider "aws" {
  alias  = "users"
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.users
  }
}

provider "aws" {
  alias  = "nonprod"
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.nonprod
  }
}

provider "aws" {
  alias  = "prod"
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_roles.prod
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
