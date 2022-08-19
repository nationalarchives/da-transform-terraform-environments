variable "environment_name" {
  description = "Name of the environment to deploy"
  type = string

  validation {
    condition     = contains(["dev", "test", "int", "staging", "prod"], var.environment_name)
    error_message = "Allowed values for environment_name are \"dev\", \"int\",, \"staging\" or \"prod\"."
  }
}

variable "prefix" {
  description = "Transformation Engine prefix"
  type = string
  default = "tre"
}

variable "assume_role" {
  description = "role ARNs to be assumed"
  type = string
}

variable "tdr_role_arn" {
  description = "role ARN for TDR to submit to SQS queues"
  type = string
}

variable "tdr_sqs_queue_endpoint" {
  description = "Endpoint of the TDR SQS Queue for the retry message"
  type = string
}

variable "tdr_sqs_queue_arn" {
  description = "ARN of the TDR SQS Queue for the retry message"
  type = string
}

variable "tdr_sqs_retry_url" {
  description = "The TDR retry SQS Queue URL"
  type = string
}

variable "tdr_sqs_retry_arn" {
  description = "The TDR retry SQS Queue ARN"
  type = string
}

variable "tdr_queue_kms_key" {
  description = "ARN of the KMS Key for TDR SQS Queue "
  type = string
}

variable "editorial_role_arn" {
  description = "role ARN for editorial retry message"
  type        = string
}

variable "editorial_sns_sub_arn" {
  description = "ARN of the editorial SNS Subscription role"
  type = string
}

variable "tre_version" {
  description = "TRE Step Function version (update if Step Function flow or called Lambda function versions change)"
  type = string
}

variable "image_versions" {
  description = "Latest image version for Lambda Functions"
  type = object({
    tre_step_function_trigger = string
    tre_bagit_checksum_validation = string
    tre_files_checksum_validation = string
    tre_prepare_parser_input = string
    tre_editorial_integration = string
    tre_run_judgment_parser = string
    tre_slack_alerts = string
  })
}

variable "vb_version" {
  description = "Validate BagIt Step Function version (update if Step Function flow or called Lambda function versions change)"
  type = string
}

variable "vb_image_versions" {
  description = "Latest image version for Lambda Functions"
  type = object({
    tre_vb_trigger = string
    tre_vb_validate_bagit = string
    tre_vb_validate_bagit_files = string
  })
}

# Slack Alerts

variable "slack_webhook_url" {
  description = "Webhook URL for tre slack alerts"
  type = string
}

variable "slack_channel" {
  description = "Channel name for the tre slack alerts"
  type = string
}

variable "slack_username" {
  description = "Username for tre slack alerts"
  type = string
}

variable "tre_in_publishers" {
  description = "Roles that have permission to publish messages to tre-in topic"
  type = list(string)
}

variable "tre_in_subscribers" {
  description = "Roles that have permission to subscribe to tre-in topic"
  type = list(string)
}

variable "tre_internal_subscribers" {
  description = "Roles that have permission to subscribe to tre-internal topic"
  type = list(string)  
}

variable "tre_out_subscribers" {
  description = "Roles that have permission to subscribe to tre-out topic"
  type = list(string)
}
