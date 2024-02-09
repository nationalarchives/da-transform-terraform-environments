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
      output_artifacts = ["source_output"]

      configuration = {
        //break the link so V1 pipeline stops being triggered
        //BranchName           = "main"
        BranchName           = "run-only-on-push-to-non-existent-branch"
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
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = aws_codebuild_project.parser_test.name
      }
    }
  }

  stage {
    name = "DeployDev"
    action {
      name            = "DeployDev"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_dev.name
      }
    }
  }

  stage {
    name = "DeployTest"
    action {
      name            = "DeployTest"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_test.name
      }
    }
  }

  stage {
    name = "DeployInt"
    action {
      name            = "DeployInt"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_int.name
      }
    }
  }

  stage {
    name = "DeployStaging"
    action {
      name            = "DeployStaging"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_staging.name
      }
    }
  }

  stage {
    name = "DeployProd"
    action {
      name            = "DeployProd"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        "ProjectName" = aws_codebuild_project.parser_deployment_prod.name
      }
    }
  }
}
