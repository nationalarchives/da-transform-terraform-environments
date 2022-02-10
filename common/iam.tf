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
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "terraform" {
  name               = "terraform"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.terraform-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role       = aws_iam_role.terraform.name
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

resource "aws_iam_role" "codeipeline_role" {
  name = "codepipeline_role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.codepipeline-assume-role-policy.json
}


resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name = "codepipeline_role_policy"
  role = aws_iam_role.codeipeline_role.name
  policy = file("${path.module}/templates/codepipeline-role-policy.json.tpl", {
    codepipeline_bucket_arn = aws_s3_bucket.codepipeline_bucket.arn
    codebuild_arn           = aws_codebuild_project.terraform-common-apply.arn
  })
}


