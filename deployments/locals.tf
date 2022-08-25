locals {
  tre_internal_subscriptions = [
    {
      type = "AWS"
      role_arn = "arn:aws:iam::${data.aws_caller_identity.aws.account_id}:root"
      name = "dpsg-in-sqs-queue"
      protocol = "sqs"
      endpoint = module.dri_preingest_sip_generation.dpsg_in_queue_arn
      filter_policy = jsonencode({
            "name": ["TRE"],
            "process": ["dev-tre-validate-bagit"],
            "event-name": ["bagit-validated"],
            "type": ["standard"]
      })
    },
  ]
}