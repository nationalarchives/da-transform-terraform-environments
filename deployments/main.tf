# module "pipeline_step_function" {
#   source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test_branch//step_function"
#   env = var.environment_name
# }

module "tdr_sqs_in_queue" {
  source = "github.com/nationalarchives/da-transform-terraform-modules?ref=test_branch//sqs"
  env = var.environment_name
  tdr_role_arn = var.tdr_role_arn
  sfn_arn = "arn:aws:states:eu-west-2:882876621099:stateMachine:dev-te-state-machine"
}
