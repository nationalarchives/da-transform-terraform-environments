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
      name             = "Source-${var.git_repository_link}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.git_repository_link
        BranchName     = "feature/codepipeline"
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 2
      input_artifacts = ["source_output"]

    }
  }
}

resource "aws_codestarconnections_connection" "terraform-codepipeline" {
  name          = "terraform-common-codepipeline"
  provider_type = "GitHub"
}
