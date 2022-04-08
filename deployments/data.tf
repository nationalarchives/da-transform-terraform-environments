data "aws_caller_identity" "aws" {
  provider = aws
}

data "aws_caller_identity" "current" {}