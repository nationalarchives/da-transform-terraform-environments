# Common CodeBuild projects

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


# Lambda image deployemnts CodeBuild project

resource "aws_codebuild_project" "lambda-image-deploy" {
  for_each      = local.environments
  name          = "lambda-image-${each.key}-deploy"
  description   = "Lambda functions image deploy-${each.key}"
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

    # environment_variable {
    #   name = "TF_IN_AUTOMATION"
    #   value = "True"
    #   type = "PLAINTEXT"
    # }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-lambda-image-${each.key}-pipeline-logs"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "./buildspec.yaml"
    git_clone_depth = 0
  }
}

# parser CodeBuild projects


resource "aws_codebuild_project" "parser-build" {
  name          = "parser-build"
  description   = "CodeBuild for building parser image"
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
      name  = "AWS_REGION"
      value = "eu-west-2"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.mgmt.account_id
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URL"
      value = aws_ecr_repository.tre_run_judgment_parser.repository_url
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-buildspec.yaml")
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

resource "aws_codebuild_project" "parser_test" {
  name          = "parser-test"
  description   = "Codebuild for testing latest parser image"
  build_timeout = "15"
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
      name  = "PARSER_TEST_S3_BUCKET"
      value = aws_s3_bucket.dev_tre_test_data.bucket
    }
    
    environment_variable {
      name  = "PARSER_TEST_S3_PATH_DATA_OK"
      value = "parser/ok/"
    }
    
    environment_variable {
      name  = "PARSER_TEST_S3_PATH_DATA_FAIL"
      value = "parser/fail/"
    }
    
    environment_variable {
      name  = "PARSER_TEST_S3_PATH_OUTPUT"
      value = "parser/output-tmp/"
    }
    
    environment_variable {
      name  = "PARSER_TEST_TESTDATA_SUFFIX"
      value = ".docx"
    }
    
    environment_variable {
      name  = "PARSER_TEST_LAMBDA"
      value = aws_lambda_function.test_judgment_parser.function_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-test-buildspec.yaml")
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


resource "aws_codebuild_project" "parser_deployment_dev" {
  name          = "parser-deployment-dev"
  description   = "Codebuild for dploying latest parser image to dev"
  build_timeout = "15"
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
      name = "NON_PROD_ROLE_ARN"
      value = aws_iam_role.nonprod_cross_account_terraform.arn
    }

    environment_variable {
      name  = "ECR_PARSER_IMAGE_NAME"
      value = aws_ecr_repository.tre_run_judgment_parser.name
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-deployment-dev-buildspec.yaml")
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

resource "aws_codebuild_project" "parser_deployment_test" {
  name          = "parser-deployment-test"
  description   = "Codebuild for dploying latest parser image to test"
  build_timeout = "15"
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
      name = "NON_PROD_ROLE_ARN"
      value = aws_iam_role.nonprod_cross_account_terraform.arn
    }

    environment_variable {
      name  = "ECR_PARSER_IMAGE_NAME"
      value = aws_ecr_repository.tre_run_judgment_parser.name
    }

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
      name = "MANAGMENT_ROLE_ARN"
      value = aws_iam_role.mgmt_terraform.arn
    }

    environment_variable {
      name = "S3_TEST_DATA_BUCKET"
      value = aws_s3_bucket.dev_tre_test_data.bucket
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-deployment-test-buildspec.yaml")
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

resource "aws_codebuild_project" "parser_deployment_int" {
  name          = "parser-deployment-int"
  description   = "Codebuild for dploying latest parser image to int"
  build_timeout = "15"
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
      name = "NON_PROD_ROLE_ARN"
      value = aws_iam_role.nonprod_cross_account_terraform.arn
    }

    environment_variable {
      name  = "ECR_PARSER_IMAGE_NAME"
      value = aws_ecr_repository.tre_run_judgment_parser.name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-deployment-int-buildspec.yaml")
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

resource "aws_codebuild_project" "parser_deployment_staging" {
  name          = "parser-deployment-staging"
  description   = "Codebuild for dploying latest parser image to staging"
  build_timeout = "15"
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
      name = "PROD_ROLE_ARN"
      value = aws_iam_role.prod_cross_account_terraform.arn
    }

    environment_variable {
      name  = "ECR_PARSER_IMAGE_NAME"
      value = aws_ecr_repository.tre_run_judgment_parser.name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-deployment-staging-buildspec.yaml")
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

resource "aws_codebuild_project" "parser_deployment_prod" {
  name          = "parser-deployment-prod"
  description   = "Codebuild for dploying latest parser image to prod"
  build_timeout = "15"
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
      name = "PROD_ROLE_ARN"
      value = aws_iam_role.prod_cross_account_terraform.arn
    }

    environment_variable {
      name  = "ECR_PARSER_IMAGE_NAME"
      value = aws_ecr_repository.tre_run_judgment_parser.name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "da-transform-parser-pipeline-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("files/parser-deployment-prod-buildspec.yaml")
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

