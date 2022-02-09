resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.pipeline_deployment_bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  # Neede for CloudWatch
  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "pipeline_buckets" {

  bucket                  = aws_s3_bucket.codepipeline_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}