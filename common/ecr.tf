resource "aws_ecr_repository" "tre_slack_alerts" {
  name                 = "lambda_functions/tre-slack-alerts"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "tre_step_function_trigger" {
  name                 = "lambda_functions/tre-step-function-trigger"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_bagit_checksum_validation" {
  name                 = "lambda_functions/tre-bagit-checksum-validation"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_files_checksum_validation" {
  name                 = "lambda_functions/tre-files-checksum-validation"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_prepare_parser_input" {
  name                 = "lambda_functions/tre-prepare-parser-input"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_run_judgment_parser" {
  name                 = "lambda_functions/tre-run-judgment-parser"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "tre_run_judgment_parser_policy" {
  repository = aws_ecr_repository.tre_run_judgment_parser.name
  policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "LambdaECRImageRetrievalPolicy",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "${aws_iam_role.parser_pipeline_alerts_role.arn}",
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : [
            "ecr:BatchGetImage",
            "ecr:DeleteRepositoryPolicy",
            "ecr:DescribeImages",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:SetRepositoryPolicy"
          ],
          "Condition" : {
            "StringLike" : {
              "aws:sourceArn" : "arn:aws:sts::454286877087:assumed-role/*/*"
            }
          }
        },
        {
          "Action" : [
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:SetRepositoryPolicy",
            "ecr:DeleteRepositoryPolicy",
            "ecr:GetRepositoryPolicy",
          ]
          "Condition" : {
            "StringLike" : {
              "aws:sourceArn" : "arn:aws:lambda:eu-west-2:454286877087:function:*"
            }
          }
          "Effect" : "Allow"
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          }
          "Sid" : "LambdaECRImageRetrievalPolicy"
        }
      ]
    }
  )
}

resource "aws_ecr_repository" "tre_editorial_integration" {
  name                 = "lambda_functions/tre-editorial-integration"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
