resource "aws_codestarconnections_connection" "terraform-codepipeline" {
  lifecycle {
    prevent_destroy = true
  }
  name          = "terraform-common-codepipeline"
  provider_type = "GitHub"
}
