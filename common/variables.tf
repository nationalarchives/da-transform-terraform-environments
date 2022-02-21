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

variable "git_repository_link" {
  description = "Source repository link for the pipeline"
  type = string
}

variable "pipeline_deployment_bucket_name" {
  description = "S3 bucket name"
  type = string
}

variable "da_codebuild_logs" {
  description = "CW Logs group name"
  type = string
}

variable "github_oauth_token" {
  description = "GitHub v1 oauth token"
  type = string
}

variable "common_git_branch" {
  description = "Git branch for common terraform"
  type = string
  default = "master"
}

variable "dev_git_branch" {
  description = "Git branch for dev terraform"
  type = string
  default = "develop"
}

variable "int_git_branch" {
  description = "Git branch for int terraform"
  type = string
  default = "develop"
}

variable "staging_git_branch" {
  description = "Git branch for staging terraform"
  type = string
  default = "master"
}

variable "prod_git_branch" {
  description = "Git branch for production terraform"
  type = string
  default = "master"
}
