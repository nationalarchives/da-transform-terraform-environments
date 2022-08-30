variable "assume_roles" {
  description = "role ARNs to be assumed"
  type = object({
    root    = string
    users   = string
    nonprod = string
    prod    = string
  })
}
#
#variable "groups" {
#  description = "List of groups to be provisioned"
#  type = list(object({
#    name = string
#    rolearns = list(string)
#  }))
#}

variable "users" {
  description = "List of users to provision and their group memberships"
  type = list(object({
    name   = string
    groups = list(string)
  }))
}

# CodePipeline Variables

variable "common_git_branch" {
  description = "Git branch for common terraform"
  type        = string
}

variable "dev_git_branch" {
  description = "Git branch for dev terraform"
  type        = string
}

variable "test_git_branch" {
  description = "Git branch for test terraform"
  type        = string
}

variable "int_git_branch" {
  description = "Git branch for int terraform"
  type        = string
}

variable "staging_git_branch" {
  description = "Git branch for staging terraform"
  type        = string
}

variable "prod_git_branch" {
  description = "Git branch for production terraform"
  type        = string
}

variable "slack_webhook_url" {
  description = "Webhook URL for tre slack alerts"
  type        = string
}

variable "slack_channel" {
  description = "Channel name for the tre slack alerts"
  type        = string
}

variable "slack_username" {
  description = "Username for tre slack alerts"
  type        = string
}

# variable "assume_role_external_id" {
#   description = "External_id for cross-account assume role"
#   type = string
# }

# AWS Athena
variable "queries" {
  description = "comma separated list of queries"
  default     = ["tre_cloudtrail_logs_mgmt", "create_table_tre_cloudtrail_logs_mgmt"]
}

variable "environment" {
  description = "Environment variable"
  default     = "management"
}