variable "assume_roles" {
  description = "role ARNs to be assumed"
  type = object({
    root    = string
    users   = string
    nonprod = string
    prod    = string
  })
}

variable "groups" {
  description = "List of groups to be provisioned"
  type = list(object({
    name     = string
    rolearns = list(string)
  }))
}

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
