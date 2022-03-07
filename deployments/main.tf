module "pipeline_step_function" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test_branch//step_function"
  env = var.environment_name
  tdr_sqs_queue_endpoint = var.tdr_sqs_queue_endpoint
  tdr_sqs_queue_arn = var.tdr_sqs_queue_arn
}

module "tdr_sqs_in_queue" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test_branch//sqs"
  env = var.environment_name
  tdr_role_arn = var.tdr_role_arn
  sfn_arn = module.pipeline_step_function.sfn_state_machine_arn
}
