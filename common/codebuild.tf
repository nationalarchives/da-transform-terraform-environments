#resource "aws_codebuild_project" "terraform-common-apply" {
#  name = "terraform-common-apply"
#  description = "Terraform common apply"
#  build_timeout = "5"
#  service_role = aws_iam_role.terraform.arn
#
#  artifacts {
#    type = "NO_ARTIFACTS"
#  }
#
#  environment {
#    compute_type = "BUILD_GENERAL1_SMALL"
#    image = "
#  }
#}
