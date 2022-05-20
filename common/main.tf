module "iamusers" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=dev//iamusers"
  users  = var.users
  groups = local.groups

  providers = {
    aws = aws.users
  }
}
