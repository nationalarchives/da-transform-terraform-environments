resource "aws_codebuild_project" "terraform-common-apply" {
  name          = "terraform-common-apply"
  description   = "Terraform common apply"
  build_timeout = "5"
  service_role  = aws_iam_role.terraform.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = var.da_codebuild_logs
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.yaml"
  }
}
