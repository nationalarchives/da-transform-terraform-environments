data "aws_caller_identity" "mgmt" {
  provider = aws
}

data "aws_caller_identity" "users" {
  provider = aws.users
}

data "aws_caller_identity" "nonprod" {
  provider = aws.nonprod
}

data "aws_caller_identity" "prod" {
  provider = aws.prod
}
