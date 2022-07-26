resource "aws_codebuild_project" "tre_lambda_image_build" {
  name = "tre_lambda_image_build"
  description   = "CodeBuild for building docker images for lambda"
  build_timeout = "5"
  service_role  = aws_iam_role.mgmt_terraform.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.mgmt.account_id
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/lamda-deployment-buildspec.yaml")
  }
}
