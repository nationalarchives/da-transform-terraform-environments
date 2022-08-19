locals {
  tre_internal_subscriptions = [
    {
      name = "dpsg-in-sqs-queue"
      protocol = "sqs"
      endpoint = module.dri_preingest_sip_generation.dpsg_in_queue_arn
      filter_policy = jsonencode({
            "name": ["TRE"],
            "process": ["dev-tre-receive-and-process-bag"],
            "event-name": ["bagit-validated"],
            "type": ["standard"]
      })
    },
  ]
}