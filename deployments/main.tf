module "pipeline_step_function" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=develop//step_function"
  env = var.environment_name
  tdr_sqs_queue_endpoint = var.tdr_sqs_queue_endpoint
  tdr_sqs_queue_arn = var.tdr_sqs_queue_arn
  tdr_queue_kms_key = var.tdr_queue_kms_key
  tdr_trigger_queue_arn = module.tdr_sqs_in_queue.tdr_sqs_queue_arn
  editorial_retry_trigger_arn = module.tdr_sqs_in_queue.editorial_sqs_queue_arn
  editorial_sns_sub_arn = var.editorial_sns_sub_arn
  api_endpoint = "${module.parser.parser_api_endpoint}/${module.parser.lambda_name}"
}

module "tdr_sqs_in_queue" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=develop//sqs"
  env = var.environment_name
  tdr_role_arn = var.tdr_role_arn
  sfn_arn = module.pipeline_step_function.sfn_state_machine_arn
  editorial_role_arn = var.editorial_role_arn
}

module "parser" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=develop//parser"
  env = var.environment_name
}
