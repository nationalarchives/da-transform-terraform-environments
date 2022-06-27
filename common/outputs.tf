output "roles" {
  value = [
    {
      name = "DevOps"
      rolearns = {
        mgmt    = aws_iam_role.mgmt_cross_account_admin.arn,
        nonprod = aws_iam_role.nonprod_cross_account_admin.arn,
        prod    = aws_iam_role.prod_cross_account_admin.arn
      }
    },
    {
      name = "Developers"
      rolearns = {
        mgmt    = aws_iam_role.mgmt_cross_account_dev.arn,
        nonprod = aws_iam_role.nonprod_cross_account_dev.arn,
        prod    = aws_iam_role.prod_cross_account_dev.arn
      }
    },
    {
      name = "tna-users"
      rolearns = {
        nonprod = aws_iam_role.nonprod_cross_account_tna_user.arn,
        prod    = aws_iam_role.prod_cross_account_tna_user.arn
      }
    }
  ]
}

output "account_ids" {
  value = {
    mgmt    = data.aws_caller_identity.mgmt.id,
    users   = data.aws_caller_identity.users.id,
    nonprod = data.aws_caller_identity.nonprod.id
    prod    = data.aws_caller_identity.prod.id
  }
}
