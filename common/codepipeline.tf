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
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
				Branch         = "feature/codepipeline"
        Owner          = "nationalarchives"
        PollForSourceChanges = "false"
        Repo           = "da-transform-terraform-environments"
        OAuthToken     = var.github_oauth_token
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

resource "aws_codestarconnections_connection" "terraform-codepipeline" {
  name          = "terraform-common-codepipeline"
  provider_type = "GitHub"
}
