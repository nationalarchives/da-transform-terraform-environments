locals {
  tre_in_subscriptions = [
    {
      name     = "vb-in-sqs-queue"
      protocol = "sqs"
      endpoint = module.validate_bagit.tre_vb_in_queue_arn
    }
  ]
}

locals {
  tre_out_subscriptions = []
}

locals {
  tre_internal_subscriptions = [
    {
      name     = "dpsg-in-sqs-queue"
      protocol = "sqs"
      endpoint = module.dri_preingest_sip_generation.dpsg_in_queue_arn
      filter_policy = jsonencode({
        "name" : ["TRE"],
        "process" : ["${var.environment_name}-tre-validate-bagit"],
        "event-name" : ["bagit-validated"],
        "type" : ["standard"]
      })
    },
    {
      name          = "tre-forward-queue"
      protocol      = "sqs"
      endpoint      = module.common.tre_forward_queue_arn
      filter_policy = ""
    }
  ]
}


