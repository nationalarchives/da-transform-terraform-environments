# Common terraform CodeBuild projects

resource "aws_codebuild_project" "terraform-common-apply" {
  name          = "terraform-common-apply"
  description   = "Terraform common apply"
  build_timeout = "20"
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
      name  = "TERRAFORM_VARS"
      value = "codepipeline-tfvars"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TERRAFORM_BACKEND_CONF"
      value = "codepipeline-tfbackend"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "True"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-terraform-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.yaml"
  }
}

# terraform deployments CodeBuild projetcs

resource "aws_codebuild_project" "terraform-deployments-plan" {
  for_each      = local.environments
  name          = "terraform-${each.key}-plan"
  description   = "Terraform ${each.key} plan"
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

    environment_variable {
      name  = "TERRAFORM_VARS"
      value = "${each.key}-tfvars"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TERRAFORM_BACKEND_CONF"
      value = "${each.key}-backend"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "True"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-terraform-${each.key}-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.deployments.yaml"
  }
}

resource "aws_codebuild_project" "terraform-deployments-apply" {
  for_each      = local.environments
  name          = "terraform-${each.key}-apply"
  description   = "Terraform ${each.key} apply"
  build_timeout = "20"
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
      name  = "TERRAFORM_VARS"
      value = "${each.key}-tfvars"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TERRAFORM_BACKEND_CONF"
      value = "${each.key}-backend"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "True"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-terraform-${each.key}-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.deployments-apply.yaml"
  }
}

# TEST Stage CodeBuild Projects 

resource "aws_codebuild_project" "terraform-test-plan" {
  name          = "terraform-test-plan"
  description   = "Terraform test plan"
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

    environment_variable {
      name  = "TERRAFORM_VARS"
      value = "test-tfvars"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TERRAFORM_BACKEND_CONF"
      value = "test-backend"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "True"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-terraform-test-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.deployments.yaml"
  }
}

resource "aws_codebuild_project" "terraform-test-apply" {
  name          = "terraform-test-apply"
  description   = "Terraform test apply"
  build_timeout = "20"
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
      name  = "TERRAFORM_VARS"
      value = "test-tfvars"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TERRAFORM_BACKEND_CONF"
      value = "test-backend"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "True"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-terraform-test-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.deployments-apply.yaml"
  }
}

resource "aws_codebuild_project" "terraform-test-test" {
  name          = "terraform-test-test"
  description   = "Terraform test test"
  build_timeout = "20"
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
      name  = "TEST_ENV_CONFIG"
      value = "test-env-config"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TEST_CONSIGNMENTS"
      value = "test-consignments"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name = "NON_PROD_ROLE_ARN"
      value = aws_iam_role.nonprod_cross_account_terraform.arn
    }

    environment_variable {
      name = "MANAGMENT_ROLE_ARN"
      value = aws_iam_role.mgmt_terraform.arn
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-terraform-test-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.deployments-test.yaml"
  }

  secondary_sources {
    source_identifier = "teDockerBuild"
    type              = "GITHUB"
    git_clone_depth   = 0
    location          = "https://github.com/nationalarchives/da-transform-judgments-pipeline.git"

  }

  secondary_source_version {
    source_identifier = "teDockerBuild"
    source_version    = "develop"
  }
}
