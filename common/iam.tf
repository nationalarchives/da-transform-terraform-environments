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
  name = "codepipeline_role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.codepipeline-assume-role-policy.json
}

data "aws_iam_policy_document" "codepipeline_role_policy" {
  statement {
    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:List*"
    ]
    resources = [ "${aws_s3_bucket.codepipeline_bucket.arn}/*", aws_s3_bucket.codepipeline_bucket.arn ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [ "arn:aws:codebuild:eu-west-2:454286877087:*" ]
  }

  statement {
    actions = [ "sts:AssumeRole" ]
    resources = [
			aws_iam_role.mgmt_terraform.arn,
			aws_iam_role.users_cross_account_terraform.arn,
			aws_iam_role.nonprod_cross_account_terraform.arn,
			aws_iam_role.prod_cross_account_terraform.arn
    ]
  }

  statement {
		actions = [ "codestar-connections:UseConnection" ]
		resources = [ aws_codestarconnections_connection.tna_github.arn ]
  }
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name = "codepipeline_role_policy"
  role = aws_iam_role.codepipeline_role.name
  policy = data.aws_iam_policy_document.codepipeline_role_policy.json
#  policy = templatefile("${path.module}/templates/codepipeline-role-policy.json.tfpl", {
#    codepipeline_bucket_arn = aws_s3_bucket.codepipeline_bucket.arn
#    codebuild_arn           = aws_codebuild_project.terraform-common-apply.arn
#    codestar_connection_arn = aws_codestarconnections_connection.terraform-codepipeline.arn
#    terraform_roles         = jsonencode(local.terraform_roles)
#  })
}

