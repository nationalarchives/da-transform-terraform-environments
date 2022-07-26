# Common pipeline 
resource "aws_codepipeline" "terraform-common" {
  name     = "terraform-common"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId = "nationalarchives/da-transform-terraform-environments"
        BranchName       = var.common_git_branch
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 2
      input_artifacts = ["source_output"]
      output_artifacts = ["plan_output"]
      configuration = {
        ProjectName = aws_codebuild_project.terraform-common-plan.name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name      = "Approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 3
    }
  }

  stage {
    name = "Apply"
    action {
      name      = "Apply"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 4
      input_artifacts = [
        "source_output",
        "plan_output"
      ]
      configuration = {
        ProjectName   = aws_codebuild_project.terraform-common-apply.name
        PrimarySource = "source_output"
      }
    }
  }

  #  lifecycle {
  #    ignore_changes = [stage[0].action[0].configuration]
  #  }
}

# ------------------------------
# terrafrom deployments pipeline

resource "aws_codepipeline" "terraform-deployments" {
  for_each = local.environments
  name     = "terraform-${each.key}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
        BranchName       = each.value.git_branch
        ConnectionArn    = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId = "nationalarchives/da-transform-terraform-environments"

      }
    }
  }

  stage {
    name = "Plan"
    action {
      name             = "Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      configuration = {
        ProjectName = aws_codebuild_project.terraform-deployments-plan[each.key].name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name      = "Approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 3
    }
  }

  stage {
    name = "Apply"
    action {
      name      = "Apply"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 4
      input_artifacts = [
        "source_output",
        "plan_output"
      ]
      configuration = {
        ProjectName   = aws_codebuild_project.terraform-deployments-apply[each.key].name
        PrimarySource = "source_output"
      }
    }
  }
}

# # TEST Environment Pipeline


resource "aws_codepipeline" "terraform-test-test" {
  name     = "terraform-test"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
        BranchName       = var.test_git_branch
        ConnectionArn    = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId = "nationalarchives/da-transform-terraform-environments"

      }
    }
  }

  stage {
    name = "Plan"
    action {
      name             = "Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      configuration = {
        ProjectName = aws_codebuild_project.terraform-test-plan.name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name      = "Approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 3
    }
  }

  stage {
    name = "Apply"
    action {
      name      = "Apply"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 4
      input_artifacts = [
        "source_output",
        "plan_output"
      ]
      configuration = {
        ProjectName   = aws_codebuild_project.terraform-test-apply.name
        PrimarySource = "source_output"
      }
    }
  }

  stage {
    name = "Test"
    action {
      name = "Test"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 5
      input_artifacts = [ "source_output" ]
      configuration = {
        ProjectName = aws_codebuild_project.terraform-test-test.name
      }
    }
  }
}

# ------------------------------
# lambda deployments pipeline


resource "aws_codepipeline" "lambda_deployments" {
  for_each = local.environments
  name     = "lambda-deployments-${each.key}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
        BranchName           = each.value.git_branch
        ConnectionArn        = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId     = "nationalarchives/da-transform-judgments-pipeline"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 2
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.lambda-image-deploy[each.key].name
      }
    }
  }
}
# ------------------------------
# parser deployments pipeline

resource "aws_codepipeline" "parser-deployments" {

  name     = "parser-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
        BranchName           = "main"
        ConnectionArn        = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId     = "nationalarchives/tna-judgments-parser"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 2
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.parser-build.name
      }
    }
  }

  stage {
    name = "Test"
    action {
      name            = "Test"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 3
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.parser_test.name
      }
    }
  }


  stage {
    name = "DeployDev"
    action {
      name = "DeployDev"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 5
      input_artifacts = [ "source_output" ]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_dev.name
      }
    }
  }
  stage {
    name = "DeployTest"
    action {
      name = "DeployTest"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 6
      input_artifacts = [ "source_output" ]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_test.name
      }
    }
  }
  stage {
    name = "DeployInt"
    action {
      name = "DeployInt"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 7
      input_artifacts = [ "source_output" ]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_int.name
      }
    }
  }
  stage {
    name = "DeployStaging"
    action {
      name = "DeployStaging"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 8
      input_artifacts = [ "source_output" ]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_staging.name
      }
    }
  }
  stage {
    name = "DeployProd"
    action {
      name = "DeployProd"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 9
      input_artifacts = [ "source_output" ]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_prod.name
      }
    }
  }



}

resource "aws_codestarconnections_connection" "terraform-codepipeline" {
  lifecycle {
    prevent_destroy = true
  }
  name          = "terraform-common-codepipeline"
  provider_type = "GitHub"
}

