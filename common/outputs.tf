
output "account_ids" {
  value = {
    mgmt    = data.aws_caller_identity.mgmt.id
    nonprod = data.aws_caller_identity.nonprod.id
    prod    = data.aws_caller_identity.prod.id
  }
}
