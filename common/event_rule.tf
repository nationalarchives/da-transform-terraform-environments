#resource "aws_cloudwatch_event_rule" "parser_pipeline_test_stage" {
#  name = "parser-pipeline-test-stage-fail"
#  event_pattern = jsonencode(
#    {
#      detail = {
#        pipeline = [
#          "parser-pipeline",
#        ]
#        stage = [
#          "Build", "Test", "DeployDev", "DeployTest", "DeployInt", "DeployStaging", "DeployProd",
#        ]
#        state = [
#          "FAILED", "CANCELED"
#        ]
#      }
#      detail-type = [
#        "CodePipeline Stage Execution State Change",
#      ]
#      source = [
#        "aws.codepipeline",
#      ]
#    }
#  )
#}
#
#resource "aws_cloudwatch_event_target" "parser_pipeline_test_stage" {
#  rule = aws_cloudwatch_event_rule.parser_pipeline_test_stage.name
#  arn  = aws_sns_topic.parser_pipeline_alerts.arn
#  input_transformer {
#    input_paths = {
#      "pipeline" = "$.detail.pipeline"
#      "stage"    = "$.detail.stage"
#      "state"    = "$.detail.state"
#    }
#    input_template = "\" `<pipeline>` <state> at `<stage>` Stage \""
#  }
#}
#
#resource "aws_cloudwatch_event_rule" "parser_pipeline_started" {
#  name = "parser-pipeline-started"
#  event_pattern = jsonencode(
#    {
#      detail = {
#        pipeline = [
#          "parser-pipeline",
#        ]
#        state = [
#          "STARTED", "SUCCEEDED"
#        ]
#      }
#      detail-type = [
#        "CodePipeline Pipeline Execution State Change",
#      ]
#      source = [
#        "aws.codepipeline",
#      ]
#    }
#  )
#}
#
#resource "aws_cloudwatch_event_target" "parser_pipeline_started" {
#  rule = aws_cloudwatch_event_rule.parser_pipeline_started.name
#  arn  = aws_sns_topic.parser_pipeline_alerts.arn
#  input_transformer {
#    input_paths = {
#      "pipeline" = "$.detail.pipeline"
#      "stage"    = "$.detail.stage"
#      "state"    = "$.detail.state"
#    }
#    input_template = "\" `<pipeline>` <state>\""
#  }
#}
#
