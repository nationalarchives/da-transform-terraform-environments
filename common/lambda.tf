resource "aws_lambda_function" "test_judgment_parser" {
  image_uri     = "${aws_ecr_repository.tre_run_judgment_parser.repository_url}:latest"
  package_type  = "Image"
  function_name = "test_judgment_parser"
  role          = aws_iam_role.test_judgment_parser_lambda_role.arn
  memory_size   = 1536
  timeout       = 900

  tags = {
    "ApplicationType" = ".NET"
  }
}