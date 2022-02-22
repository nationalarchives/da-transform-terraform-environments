module "pipeline_step_function" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test_branch//step_function"
  env = var.environment_name
}

module "tdr_sqs_in_queue" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test_branch//sqs"
  env = var.environment_name
  tdr_role_arn = var.tdr_role_arn
  sfn_arn = module.pipeline_step_function.sfn_state_machine_arn
}
