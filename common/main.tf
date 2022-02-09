module "iamusers" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=develop//iamusers"
  users  = var.users
  groups = var.groups
  
  providers = {
    aws = aws.users
  }
}
