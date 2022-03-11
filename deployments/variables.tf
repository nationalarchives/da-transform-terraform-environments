variable "environment_name" {
  description = "Name of the environment to deploy"
  type = string

  validation {
    condition     = contains(["dev", "int", "staging", "prod"], var.environment_name)
    error_message = "Allowed values for environment_name are \"dev\", \"int\",, \"staging\" or \"prod\"."
  }
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

variable "tdr_queue_kms_key" {
  description = "ARN of the KMS Key for TDR SQS Queue "
  type = string
}

variable "editorial_role_arn" {
  description = "role ARN for editorial retry message"
  type        = string
}

# variable "editorial_sns_sub_arn" {
#   description = "ARN of the editorial SNS Subscription role"
#   type = string
# }