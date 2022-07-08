module "pipeline_step_function" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=dev//step_function"
  env = var.environment_name
  prefix = var.prefix
  tdr_sqs_queue_endpoint = var.tdr_sqs_queue_endpoint
  tdr_sqs_queue_arn = var.tdr_sqs_queue_arn
  tdr_queue_kms_key = var.tdr_queue_kms_key
  tdr_trigger_queue_arn = module.tdr_sqs_in_queue.tdr_sqs_queue_arn
  editorial_retry_trigger_arn = module.tdr_sqs_in_queue.editorial_sqs_queue_arn
  editorial_sns_sub_arn = var.editorial_sns_sub_arn
  account_id = data.aws_caller_identity.aws.account_id
  tre_version = var.tre_version
  image_versions = var.image_versions
  slack_webhook_url = var.slack_webhook_url
  slack_channel = var.slack_channel
  slack_username = var.slack_username
  receive_process_bag_lambda_access_role = module.receive_and_process_bag.receive_process_bag_lambda_invoke_role
}

module "tdr_sqs_in_queue" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=dev//sqs"
  env = var.environment_name
  prefix = var.prefix
  tdr_role_arn = var.tdr_role_arn
  sfn_arn = module.pipeline_step_function.sfn_state_machine_arn
  editorial_role_arn = var.editorial_role_arn
  account_id = data.aws_caller_identity.aws.account_id
  image_versions = var.image_versions
}

# Common

module "common" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=dev//common"
  env    = var.environment_name
  prefix = var.prefix
  account_id = data.aws_caller_identity.aws.account_id
  image_versions = var.image_versions
  sfn_arns = [
    module.receive_and_process_bag.receive_and_process_bag_arn
  ]
  slack_webhook_url = var.slack_webhook_url
  slack_channel = var.slack_channel
  slack_username = var.slack_username
}

# Receive and process bag

module "receive_and_process_bag" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=dev//step_functions/receive_and_process_bag"
  env = var.environment_name
  prefix = var.prefix
  account_id = data.aws_caller_identity.aws.account_id
  tre_temp_bucket = module.pipeline_step_function.tre_temp_bucket
  rapb_image_versions = var.rapb_image_versions
  rapb_version = var.rapb_version
  common_tre_slack_alerts_topic_arn = module.common.common_tre_slack_alerts_topic_arn
  common_tre_in_sns_topic_arn = module.common.common_tre_in_sns_topic_arn
}
