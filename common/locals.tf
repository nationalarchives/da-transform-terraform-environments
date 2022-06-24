locals {
  groups = [
    {
      name = "DevOps"
      rolearns = [
        aws_iam_role.mgmt_cross_account_admin.arn,
        aws_iam_role.nonprod_cross_account_admin.arn,
        aws_iam_role.prod_cross_account_admin.arn
      ]
    },
    {
      name = "Developers"
      rolearns = [
        aws_iam_role.mgmt_cross_account_dev.arn,
        aws_iam_role.nonprod_cross_account_dev.arn,
        aws_iam_role.prod_cross_account_dev.arn
      ]
    },
    {
      name = "tna-users"
      rolearns = [
        aws_iam_role.nonprod_cross_account_tna_user.arn,
        aws_iam_role.prod_cross_account_tna_user.arn
      ]
    },
    {
      name = "security-assessors"
      rolearns = [
        aws_iam_role.mgmt_cross_account_security_assessor.arn,
        aws_iam_role.nonprod_cross_account_security_assessor.arn,
        aws_iam_role.prod_cross_account_security_assessor.arn
      ]
    }
  ]

  environments = {
    dev = {
      rolearn    = aws_iam_role.nonprod_cross_account_terraform.arn,
      git_branch = var.dev_git_branch
    },
    int = {
      rolearn    = aws_iam_role.nonprod_cross_account_terraform.arn,
      git_branch = var.int_git_branch
    },
    staging = {
      rolearn    = aws_iam_role.prod_cross_account_terraform.arn,
      git_branch = var.staging_git_branch
    },
    prod = {
      rolearn    = aws_iam_role.prod_cross_account_terraform.arn,
      git_branch = var.prod_git_branch
    }
  }

  terraform_roles = [
    aws_iam_role.mgmt_terraform.arn,
    aws_iam_role.users_cross_account_terraform.arn,
    aws_iam_role.nonprod_cross_account_terraform.arn,
    aws_iam_role.prod_cross_account_terraform.arn
  ]

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
