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
  name = "terraform"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.terraform-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role = aws_iam_role.terraform.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}
