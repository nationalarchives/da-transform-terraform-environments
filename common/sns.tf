#resource "aws_sns_topic" "parser_pipeline_alerts" {
#  name = "parser-pipeline-alerts"
#}
#
#resource "aws_sns_topic_policy" "parser_pipeline_alerts" {
#  arn    = aws_sns_topic.parser_pipeline_alerts.arn
#  policy = data.aws_iam_policy_document.test_parser_sns_alerts_policy.json
#}
#
#resource "aws_sns_topic_subscription" "parser_pipeline_alerts" {
#  topic_arn = aws_sns_topic.parser_pipeline_alerts.arn
#  protocol  = "lambda"
#  endpoint  = aws_lambda_function.parser_pipeline_slack_alerts.arn
#}
