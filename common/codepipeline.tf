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
        BranchName       = "develop"
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
      configuration = {
        ProjectName   = aws_codebuild_project.terraform-common-apply.name
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
  name = "terraform-${each.key}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type = "S3"
  }

  stage {
    name = "Source"
    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      run_order = 1
      output_artifacts = ["source_output"]

      configuration = {
        BranchName = each.value.git_branch
        ConnectionArn    = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId = "nationalarchives/da-transform-terraform-environments"
        
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name = "Plan"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 2
      input_artifacts = ["source_output"]
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
      name = "Apply"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 4
      input_artifacts = [
        "source_output",
        "plan_output"
      ]
      configuration = {
        ProjectName = aws_codebuild_project.terraform-deployments-apply[each.key].name
        PrimarySource = "source_output"
      }
    }
  }
}

# ------------------------------
# lambda deployments pipeline


resource "aws_codepipeline" "lambda_deployments" {
  for_each = local.environments
  name = "lambda-deployments-${each.key}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type = "S3"
  }

  stage {
    name = "Source"
    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      run_order = 1
      output_artifacts = ["source_output"]

      configuration = {
        BranchName = each.value.git_branch
        ConnectionArn    = aws_codestarconnections_connection.terraform-codepipeline.arn
        FullRepositoryId = "nationalarchives/da-transform-judgments-pipeline"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      run_order = 2
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.lambda-image-deploy[each.key].name
      }
    }
  }
}

resource "aws_codestarconnections_connection" "terraform-codepipeline" {
  name          = "terraform-common-codepipeline"
  provider_type = "GitHub"
}

