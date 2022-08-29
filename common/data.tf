data "aws_caller_identity" "mgmt" {
  provider = aws
}

data "aws_caller_identity" "users" {
  provider = aws.users
}

data "aws_caller_identity" "nonprod" {
  provider = aws.nonprod
}

data "aws_caller_identity" "prod" {
  provider = aws.prod
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "kms" {
  # Allow root users full management access to key
  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.mgmt.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow CloudTrail to encrypt logs"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.mgmt.account_id}:trail/${local.cloudtrail_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.mgmt.account_id}:trail/${local.cloudtrail_name}"]
    }
  }
}
