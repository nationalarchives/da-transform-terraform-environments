locals {
  group_roles = {
    mgmt = {
      devops = aws_iam_role.mgmt_cross_account_admin.arn
      developers = aws_iam_role.mgmt_cross_account_dev.arn
    },
    nonprod = {
      devops = aws_iam_role.nonprod_cross_account_admin.arn
      developers = aws_iam_role.nonprod_cross_account_dev.arn
    },
    prod = {
      devops = aws_iam_role.prod_cross_account_admin.arn
      developers = aws_iam_role.prod_cross_account_dev.arn
    }
  }

  managed_policy_attachments = {
    developers = [
      "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
      "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
      "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
      "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    ],
    terraform = [
      "arn:aws:iam::aws:policy/AdministratorAccess",
    ],
    devops = [
      "arn:aws:iam::aws:policy/AdministratorAccess",
    ]
  }
}
