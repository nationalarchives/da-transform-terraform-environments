## Cross-account role for admin
data "aws_iam_policy_document" "zaizi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.users.id}:root" ]
    }
  }
}

data "aws_iam_policy_document" "tf_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [ aws_iam_role.terraform.arn ]
    }
  }
}

resource "aws_iam_role" "mgmt_cross_account_admin" {
  name = "Zaizi_Admin_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cross_account_admin" {
  role = aws_iam_role.mgmt_cross_account_admin.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}

#tfsec:ignore:aws-iam-no-policy-wildcards This policy is intentionally permissive at this point FIXME
resource "aws_iam_policy" "mgmt_dev" {
  name = "zaizi_developers"
  path = "/zaizi/"
  description = "Zaizi Developer Permissions"
  policy = file("${path.module}/templates/dev-role.json.tftpl")
}

resource "aws_iam_role" "mgmt_cross_account_dev" {
  name = "Zaizi_Dev_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "mgmt_cross_account_dev" {
  role = aws_iam_role.mgmt_cross_account_dev.name
  policy_arn = aws_iam_policy.mgmt_dev.arn
}

## Non-Prod cross-account roles
resource "aws_iam_role" "nonprod_cross_account_admin" {
  provider = aws.nonprod
  name = "Zaizi_Admin_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "nonprod_cross_account_admin" {
  provider = aws.nonprod
  role = aws_iam_role.nonprod_cross_account_admin.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}

resource "aws_iam_role" "nonprod_cross_account_terraform" {
  provider = aws.nonprod
  name = "Terraform"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.tf_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "nonprod_cross_account_terraform" {
  provider = aws.nonprod
  role = aws_iam_role.nonprod_cross_account_terraform.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}

#tfsec:ignore:aws-iam-no-policy-wildcards This policy is intentionally permissive at this point FIXME
resource "aws_iam_policy" "nonprod_dev" {
  provider = aws.nonprod
  name = "zaizi_developers"
  path = "/zaizi/"
  description = "Zaizi Developer Permissions"
  policy = file("${path.module}/templates/dev-role.json.tftpl")
}

resource "aws_iam_role" "nonprod_cross_account_dev" {
  provider = aws.nonprod
  name = "Zaizi_Dev_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "nonprod_cross_account_dev" {
  provider = aws.nonprod
  role = aws_iam_role.nonprod_cross_account_dev.name
  policy_arn = aws_iam_policy.nonprod_dev.arn
}

## Prod cross-account roles
resource "aws_iam_role" "prod_cross_account_admin" {
  provider = aws.prod
  name = "Zaizi_Admin_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "prod_cross_account_admin" {
  provider = aws.prod
  role = aws_iam_role.prod_cross_account_admin.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}

resource "aws_iam_role" "prod_cross_account_dev" {
  provider = aws.prod
  name = "Zaizi_Dev_Role"
  path = "/zaizi/"
  assume_role_policy = data.aws_iam_policy_document.zaizi_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "prod_cross_account_dev" {
  provider = aws.prod
  role = aws_iam_role.prod_cross_account_dev.name
  policy_arn = data.aws_iam_policy.managed_readonly.arn
}

resource "aws_iam_role" "prod_cross_account_terraform" {
  provider = aws.prod
  name = "Terraform"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.tf_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "prod_cross_account_terraform" {
  provider = aws.prod
  role = aws_iam_role.prod_cross_account_terraform.name
  policy_arn = data.aws_iam_policy.managed_admin.arn
}

