#resource "aws_codepipeline" "tre_lambda_deployment" {
#  name     = "tre_lambda_deployment_v2"
#  role_arn = aws_iam_role.codepipeline_role.arn
#
#  artifact_store {
#    location = aws_s3_bucket.codepipeline_bucket.bucket
#    type     = "S3"
#  }
#
#  stage {
#    name = "Source"
#    action {
#      name             = "Source"
#      category         = "Source"
#      owner            = "AWS"
#      provider         = "CodeStarSourceConnection"
#      version          = "1"
#      output_artifacts = ["source_output"]
#
#      configuration = {
#        BranchName           = "main"
#        ConnectionArn        = aws_codestarconnections_connection.terraform-codepipeline.arn
#        FullRepositoryId     = "nationalarchives/da-transform-judgments-pipeline"
#        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
#      }
#    }
#  }
#
#  stage {
#    name = "DeployToECR"
#    action {
#      name            = "DeployToECR"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      input_artifacts = ["source_output"]
#      configuration = {
#        ProjectName = aws_codebuild_project.tre_deploy_to_ecr.name
#      }
#    }
#  }
#
#  stage {
#    name = "UpdateDevEnv"
#    action {
#      name            = "UpdateDevTFVARS"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 1
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.tre_update_dev_tfvars.name
#      }
#    }
#
#    action {
#      name            = "RunDevPipeline"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 2
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.run_pipeline_dev.name
#      }
#    }
#  }
#
#  stage {
#    name = "DeployToTestCheckPoint"
#
#    action {
#      name     = "DeployToTestCheckPoint"
#      category = "Approval"
#      owner    = "AWS"
#      provider = "Manual"
#      version  = "1"
#    }
#  }
#
#  stage {
#    name = "UpdateTestEnv"
#    action {
#      name            = "UpdateTestTFVARS"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 1
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.tre_update_test_tfvars.name
#      }
#    }
#
#    action {
#      name            = "RunTestPipeline"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 2
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.run_pipeline_test.name
#      }
#    }
#  }
#
#  stage {
#    name = "UpdateIntEnv"
#    action {
#      name            = "UpdateIntTFVARS"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 1
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.tre_update_int_tfvars.name
#      }
#    }
#
#    action {
#      name            = "RunIntPipeline"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 2
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.run_pipeline_int.name
#      }
#    }
#  }
#
#  stage {
#    name = "UpdateStagingEnv"
#    action {
#      name            = "UpdateStagingTFVARS"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 1
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.tre_update_staging_tfvars.name
#      }
#    }
#
#    action {
#      name            = "RunStagingPipeline"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 2
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.run_pipeline_staging.name
#      }
#    }
#  }
#
#  stage {
#    name = "DeployToProdCheckPoint"
#
#    action {
#      name     = "DeployToProdCheckpoint"
#      category = "Approval"
#      owner    = "AWS"
#      provider = "Manual"
#      version  = "1"
#    }
#  }
#
#  stage {
#    name = "UpdateProdEnv"
#    action {
#      name            = "UpdateProdTFVARS"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 1
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.tre_update_prod_tfvars.name
#      }
#    }
#
#    action {
#      name            = "RunProdPipeline"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      run_order       = 2
#      input_artifacts = ["source_output"]
#      configuration = {
#        "ProjectName" = aws_codebuild_project.run_pipeline_prod.name
#      }
#    }
#  }
#}