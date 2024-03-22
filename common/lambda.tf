#resource "aws_lambda_function" "test_judgment_parser" {
#  image_uri     = "${aws_ecr_repository.tre_run_judgment_parser.repository_url}:latest"
#  package_type  = "Image"
#  function_name = "test_judgment_parser"
#  role          = aws_iam_role.test_judgment_parser_lambda_role.arn
#  memory_size   = 1536
#  timeout       = 900
#
#  tags = {
#    "ApplicationType" = ".NET"
#  }
#}
#
#resource "aws_lambda_function" "parser_pipeline_slack_alerts" {
#  function_name    = "parser_pipeline_slack_alerts"
#  role             = aws_iam_role.parser_pipeline_alerts_role.arn
#  filename         = data.archive_file.log_lambda_zip.output_path
#  source_code_hash = data.archive_file.log_lambda_zip.output_base64sha256
#  handler          = "parser_pipeline_slack_alerts.lambda_handler"
#  runtime          = "python3.8"
#  timeout          = 30
#  memory_size      = 128
#
#  environment {
#    variables = {
#      SLACK_WEBHOOK_URL = var.slack_webhook_url
#      SLACK_USERNAME    = var.slack_username
#      SLACK_CHANNEL     = var.slack_channel
#    }
#  }
#
#  tags = {
#    "ApplicationType" = "Python"
#  }
#}
#
#resource "aws_lambda_permission" "parser_pipeline_slack_alerts" {
#  statement_id  = "InvokePermissionsForCWL"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.parser_pipeline_slack_alerts.function_name
#  principal     = "sns.amazonaws.com"
#  source_arn    = aws_sns_topic.parser_pipeline_alerts.arn
#
#}
#
#data "archive_file" "log_lambda_zip" {
#  type        = "zip"
#  source_file = "${path.module}/parser_pipeline_slack_alerts.py"
#  output_path = "${path.module}/parser_pipeline_slack_alerts.zip"
#}
