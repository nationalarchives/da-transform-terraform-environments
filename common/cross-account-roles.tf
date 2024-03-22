### Cross-account role for admin
#
#data "aws_iam_policy_document" "tf_assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRole"]
#
#    principals {
#      type        = "AWS"
#      identifiers = [aws_iam_role.mgmt_terraform.arn,
#        "arn:aws:iam::${data.aws_caller_identity.mgmt.account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_AdministratorAccess_bcc0fbcb60597624"]
#    }
#  }
#}
#
#resource "aws_iam_role" "nonprod_cross_account_terraform" {
#  provider           = aws.nonprod
#  name               = "terraform"
#  path               = "/"
#  assume_role_policy = data.aws_iam_policy_document.tf_assume_role_policy.json
#}
#
#resource "aws_iam_role_policy_attachment" "nonprod_cross_account_terraform" {
#  provider   = aws.nonprod
#  role       = aws_iam_role.nonprod_cross_account_terraform.name
#  policy_arn = data.aws_iam_policy.managed_admin.arn
#}
#resource "aws_iam_role" "prod_cross_account_terraform" {
#  provider           = aws.prod
#  name               = "terraform"
#  path               = "/"
#  assume_role_policy = data.aws_iam_policy_document.tf_assume_role_policy.json
#}
#
#resource "aws_iam_role_policy_attachment" "prod_cross_account_terraform" {
#  provider   = aws.prod
#  role       = aws_iam_role.prod_cross_account_terraform.name
#  policy_arn = data.aws_iam_policy.managed_admin.arn
#}
#
