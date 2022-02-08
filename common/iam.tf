## Terraform pipeline policies and permissions
data "aws_iam_policy" "admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
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
  name = "terraform"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.terraform-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role = aws_iam_role.terraform.name
  policy_arn = data.aws_iam_policy.admin.arn
}

## Cross-account role for admin
data "aws_caller_identity" "users" {
  provider = aws.users
}

data "aws_iam_policy_document" "zaizi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.users.id}:root" ]
    }
  }
}

resource "aws_iam_role" "cross_account_admin" {
  name = "Zaizi_Admin_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cross-account-admin" {
  role = aws_iam_role.cross_account_admin.name
  policy_arn = data.aws_iam_policy.admin.arn
}
