resource "aws_codepipeline" "tre_lambda_deployment" {
  name = "tre_lambda_deployment"
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
        BranchName           = "develop"
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
        ProjectName = aws_codebuild_project.tre_lambda_image_build.name
      }
    }
  }
}