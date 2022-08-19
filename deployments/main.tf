module "pipeline_step_function" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test//step_function"
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
}

module "tdr_sqs_in_queue" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test//sqs"
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
  # source = "../../da-transform-terraform-modules/common"
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test//common"
  env    = var.environment_name
  prefix = var.prefix
  account_id = data.aws_caller_identity.aws.account_id
  image_versions = var.image_versions
  sfn_role_arns = [
    module.validate_bagit.validate_bagit_role_arn
  ]
  sfn_lambda_roles = [
    module.validate_bagit.validate_bagit_lambda_invoke_role
  ]
  slack_webhook_url = var.slack_webhook_url
  slack_channel = var.slack_channel
  slack_username = var.slack_username
  tre_vb_in_queue_arn = module.validate_bagit.tre_vb_in_queue_arn
  tre_in_publishers = var.tre_in_publishers
  tre_in_subscribers = var.tre_in_subscribers
  tre_internal_publishers = [
    module.validate_bagit.validate_bagit_role_arn
  ]
  tre_internal_subscribers = var.tre_internal_subscribers
  tre_out_publishers = [
    module.validate_bagit.validate_bagit_role_arn
  ]
  tre_out_subscribers = var.tre_out_subscribers
}

# Validate BagIt

module "validate_bagit" {
  # source = "../../da-transform-terraform-modules/step_functions/validate_bagit"
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test//step_functions/validate_bagit"
  env = var.environment_name
  prefix = var.prefix
  account_id = data.aws_caller_identity.aws.account_id
  tre_data_bucket = module.common.common_tre_data_bucket
  vb_image_versions = var.vb_image_versions
  vb_version = var.vb_version
  common_tre_slack_alerts_topic_arn = module.common.common_tre_slack_alerts_topic_arn
  tdr_sqs_retry_url = var.tdr_sqs_retry_url
  tdr_sqs_retry_arn = var.tdr_sqs_retry_arn
  common_tre_internal_topic_arn = module.common.common_tre_internal_topic_arn
}
