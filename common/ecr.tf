resource "aws_ecr_repository" "tre_slack_alerts" {
  name = "lambda_functions/tre-slack-alerts"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "tre_step_function_trigger" {
  name = "lambda_functions/tre-step-function-trigger"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_bagit_checksum_validation" {
  name = "lambda_functions/tre-bagit-checksum-validation"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_files_checksum_validation" {
  name = "lambda_functions/tre-files-checksum-validation"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_prepare_parser_input" {
  name = "lambda_functions/tre-prepare-parser-input"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_run_judgment_parser" {
  name = "lambda_functions/tre-run-judgment-parser"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tre_editorial_integration" {
  name = "lambda_functions/tre-editorial-integration"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
