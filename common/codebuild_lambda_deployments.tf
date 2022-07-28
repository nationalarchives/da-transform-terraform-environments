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

resource "aws_codebuild_project" "tre_update_dev_tfvars" {
  name = "tre_update_dev_tfvars"
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
      name = "SF_TF_VAR_KEY_LIST"
      value = "tre-lambda-deploy-sf-tfvar-keys"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "ENV_TF_VARS"
      value = "dte-96-tfvars"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/tre_update_env_tfvars.yaml")
  }
}

resource "aws_codebuild_project" "tre_update_test_tfvars" {
  name = "tre_update_test_tfvars"
  description = "Codebuild for updating lambda verions in test"
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
      name = "SF_TF_VAR_KEY_LIST"
      value = "tre-lambda-deploy-sf-tfvar-keys"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "ENV_TF_VARS"
      value = "dte-96-tfvars"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/tre_update_env_tfvars.yaml")
  }
}

resource "aws_codebuild_project" "tre_update_int_tfvars" {
  name = "tre_update_int_tfvars"
  description = "Codebuild for updating lambda verions in int"
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
      name = "SF_TF_VAR_KEY_LIST"
      value = "tre-lambda-deploy-sf-tfvar-keys"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "ENV_TF_VARS"
      value = "dte-96-tfvars"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/tre_update_env_tfvars.yaml")
  }
}

resource "aws_codebuild_project" "tre_update_staging_tfvars" {
  name = "tre_update_staging_tfvars"
  description = "Codebuild for updating lambda verions in staging"
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
      name = "SF_TF_VAR_KEY_LIST"
      value = "tre-lambda-deploy-sf-tfvar-keys"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "ENV_TF_VARS"
      value = "dte-96-tfvars"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/tre_update_env_tfvars.yaml")
  }
}

resource "aws_codebuild_project" "tre_update_prod_tfvars" {
  name = "tre_update_prod_tfvars"
  description = "Codebuild for updating lambda verions in prod"
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
      name = "SF_TF_VAR_KEY_LIST"
      value = "tre-lambda-deploy-sf-tfvar-keys"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "ENV_TF_VARS"
      value = "dte-96-tfvars"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/tre_update_env_tfvars.yaml")
  }
}

resource "aws_codebuild_project" "run_pipeline_dev" {
  name = "run_pipeline_dev"
  description = "Codebuild to trigger terraform-dev pipeline"
  build_timeout = "20"
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
      name = "PIPELINE_NAME"
      value = "terraform-dev"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/run_pipeline.yaml")
  }
}

resource "aws_codebuild_project" "run_pipeline_test" {
  name = "run_pipeline_test"
  description = "Codebuild to trigger terraform-test pipeline"
  build_timeout = "20"
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
      name = "PIPELINE_NAME"
      value = "terraform-test"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/run_pipeline.yaml")
  }
}

resource "aws_codebuild_project" "run_pipeline_int" {
  name = "run_pipeline_int"
  description = "Codebuild to trigger terraform-int pipeline"
  build_timeout = "20"
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
      name = "PIPELINE_NAME"
      value = "terraform-dev"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/run_pipeline.yaml")
  }
}

resource "aws_codebuild_project" "run_pipeline_staging" {
  name = "run_pipeline_staging"
  description = "Codebuild to trigger terraform-staging pipeline"
  build_timeout = "20"
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
      name = "PIPELINE_NAME"
      value = "terraform-dev"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/run_pipeline.yaml")
  }
}

resource "aws_codebuild_project" "run_pipeline_prod" {
  name = "run_pipeline_prod"
  description = "Codebuild to trigger terraform-prod pipeline"
  build_timeout = "20"
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
      name = "PIPELINE_NAME"
      value = "terraform-dev"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-deployment-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/run_pipeline.yaml")
  }
}
