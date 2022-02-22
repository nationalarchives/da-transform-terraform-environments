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
