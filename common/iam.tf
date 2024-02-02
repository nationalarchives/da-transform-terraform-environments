## Terraform pipeline policies and permissions
data "aws_iam_policy" "managed_admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "managed_readonly" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "terraform-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com", "codepipeline.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.mgmt.account_id}:role/terraform"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.mgmt.account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_AdministratorAccess_bcc0fbcb60597624"]
    }
  }
}

resource "aws_iam_role" "mgmt_terraform" {
  name               = "terraform"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.terraform-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "mgmt_terraform" {
  role       = aws_iam_role.mgmt_terraform.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}

# Pipeline policies and permissions

data "aws_iam_policy_document" "codepipeline-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.codepipeline-assume-role-policy.json
}

data "aws_iam_policy_document" "codepipeline_role_policy" {
  statement {
    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:List*"
    ]
    resources = ["${aws_s3_bucket.codepipeline_bucket.arn}/*", aws_s3_bucket.codepipeline_bucket.arn]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["arn:aws:codebuild:eu-west-2:${data.aws_caller_identity.mgmt.account_id}:*"]
  }

  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      aws_iam_role.mgmt_terraform.arn,
      aws_iam_role.nonprod_cross_account_terraform.arn,
      aws_iam_role.prod_cross_account_terraform.arn
    ]
  }

  statement {
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.terraform-codepipeline.arn]
  }

  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.parser_pipeline_alerts.arn]
  }
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name   = "codepipeline_role_policy"
  role   = aws_iam_role.codepipeline_role.name
  policy = data.aws_iam_policy_document.codepipeline_role_policy.json
  #  policy = templatefile("${path.module}/templates/codepipeline-role-policy.json.tfpl", {
  #    codepipeline_bucket_arn = aws_s3_bucket.codepipeline_bucket.arn
  #    codebuild_arn           = aws_codebuild_project.terraform-common-apply.arn
  #    codestar_connection_arn = aws_codestarconnections_connection.terraform-codepipeline.arn
  #    terraform_roles         = jsonencode(local.terraform_roles)
  #  })
}


# Test Lambda Policies 

resource "aws_iam_role" "test_judgment_parser_lambda_role" {
  name               = "judgment-parser-test-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "test_judgment_parser_lambda_role_policy" {
  role       = aws_iam_role.test_judgment_parser_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}



# Test Data Bucket Policy

data "aws_iam_policy_document" "dev_tre_testdata_bucket_policy" {
  statement {
    actions = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", ]

    principals {
      type        = "AWS"
      identifiers = [aws_lambda_function.test_judgment_parser.role]
    }

    resources = ["${aws_s3_bucket.dev_tre_test_data.arn}/*", aws_s3_bucket.dev_tre_test_data.arn]
  }

}


# Test Parser Alerts Policy

data "aws_iam_policy_document" "test_parser_sns_alerts_policy" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.parser_pipeline_alerts.arn]
  }
}


resource "aws_iam_role" "parser_pipeline_alerts_role" {
  name               = "parser-pipeline-alerts-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "parser_pipeline_alerts_lambda_role_policy" {
  role       = aws_iam_role.parser_pipeline_alerts_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}
