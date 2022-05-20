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


variable "github_oauth_token" {
  description = "GitHub v1 oauth token"
  type        = string
}

variable "common_git_branch" {
  description = "Git branch for common terraform"
  type        = string
}

variable "dev_git_branch" {
  description = "Git branch for dev terraform"
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

variable "account_id" {
  default = "454286877087"
}


# to be deleted once slack notification set up 

variable "endpoint" {

}
