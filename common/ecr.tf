resource "aws_ecr_repository" "tna_parser" {
  name = "lambda_functions/te-text-parser"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
