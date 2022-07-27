resource "aws_codebuild_project" "tre_deploy_to_ecr" {
  name = "tre_deploy_to_ecr"
  description   = "CodeBuild for building and deploying docker images for lambda"
  build_timeout = "10"
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
    buildspec = file("files/tre_deploy_to_ecr.yaml")
  }
}

resource "aws_codebuild_project" "tre_update_dev_env" {
  name = "tre_update_dev_env"
  description = "Codebuild for updating lambda verions in dev"
  build_timeout = "10"
  service_role = aws_iam_role.mgmt_terraform.arn

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

    environment_variable {
      name = "SF_TF_VAR_KEY_LIST"
      value = "tre-lambda-deploy-sf-tfvar-keys"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "TRE_ENV"
      value = ""
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/tre_update_dev_env.yaml")
  }
}
