resource "aws_codebuild_project" "terraform-common-apply" {
  name          = "terraform-common-apply"
  description   = "Terraform common apply"
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

    environment_variable {
      name = "TERRAFORM_VARS"
      value = "codepipeline-tfvars"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "TERRAFORM_BACKEND_CONF"
      value = "codepipeline-tfbackend"
      type = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.yaml"
  }
}

resource "aws_codebuild_project" "terraform-deployments-plan" {
  for_each      = local.environments
  name          = "terraform-${each.key}-plan"
  description   = "Terraform ${each.key} plan"
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

    environment_variable {
      name = "TERRAFORM_VARS"
      value = "${each.key}-tfvars"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "TERRAFORM_BACKEND_CONF"
      value = "${each.key}-tfbackend"
      type = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.delpoyments.yaml"
  }
}
