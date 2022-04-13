resource "aws_ecr_repository" "tre_parser" {
  name = "lambda_functions/tre-judgment-parser"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "tre_slack_alerts" {
  name = "lambda_functions/tre-slack-alerts"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}