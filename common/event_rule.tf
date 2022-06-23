resource "aws_cloudwatch_event_rule" "parser_pipeline_test_stage" {
  name = "parser-pipeline-test-stage-fail"
  event_pattern = jsonencode(
    {
      detail = {
        pipeline = [
          "parser-pipeline",
        ]
        stage = [
          "Test",
        ]
        state = [
          "FAILED",
        ]
      }
      detail-type = [
        "CodePipeline Stage Execution State Change",
      ]
      source = [
        "aws.codepipeline",
      ]
    }
  )
}

resource "aws_cloudwatch_event_rule" "parser_pipeline_started" {
  name = "parser-pipeline-started"
  event_pattern = jsonencode(
    {
      detail = {
        pipeline = [
          "parser-pipeline",
        ]
        state = [
          "STARTED",
        ]
      }
      detail-type = [
        "CodePipeline Pipeline Execution State Change",
      ]
      source = [
        "aws.codepipeline",
      ]
    }
  )
}
resource "aws_cloudwatch_event_target" "parser_pipeline_test_stage" {
  rule = aws_cloudwatch_event_rule.parser_pipeline_test_stage.name
  arn  = aws_sns_topic.parser_pipeline_alerts.arn
  input_transformer {
    input_paths = {
      "pipeline" = "$.detail.pipeline"
      "stage"    = "$.detail.stage"
      "state"    = "$.detail.state"
    }
    input_template = "\"<stage> Stage <state> In <pipeline>\""
  }
}

resource "aws_cloudwatch_event_target" "parser_pipeline_started" {
  rule = aws_cloudwatch_event_rule.parser_pipeline_started.name
  arn  = aws_sns_topic.parser_pipeline_alerts.arn
  input_transformer {
    input_paths = {
      "pipeline" = "$.detail.pipeline"
      "stage"    = "$.detail.stage"
      "state"    = "$.detail.state"
    }
    input_template = "\"A New Version Of Parser Is Available And The `<pipeline>` <state>\""
  }
}

