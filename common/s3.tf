resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "da-transform-environment-pipeline-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline_buckets" {

  bucket                  = aws_s3_bucket.codepipeline_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "dev_tre_test_data" {
  bucket = "dev-te-testdata"

}

resource "aws_s3_bucket_policy" "dev_tre_test_data" {
  bucket = aws_s3_bucket.dev_tre_test_data.bucket
  policy = data.aws_iam_policy_document.dev_tre_testdata_bucket_policy.json
}



resource "aws_s3_bucket_server_side_encryption_configuration" "dev_tre_test_data" {
  bucket = aws_s3_bucket.dev_tre_test_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "dev_tre_test_data" {
  bucket = aws_s3_bucket.dev_tre_test_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "dev_tre_test_data" {
  bucket                  = aws_s3_bucket.dev_tre_test_data.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# resource "aws_s3_bucket_policy" "pipeline_bucket_policy" {
#   bucket = aws_s3_bucket.codepipeline_bucket.bucket
#   policy = data.aws_iam_policy_document.deployment_codepipeline_role_policy.json
# }

# data "aws_iam_policy_document" "deployment_codepipeline_role_policy" {
#   statement {

#     principals {
#       type = "AWS"
#       identifiers = [ "882876621099", "642021068869" ]

#     }
#     actions = [
#       "s3:Get*",
#       "s3:Put*",
#       "s3:List*"
#     ]
#     resources = [ "${aws_s3_bucket.codepipeline_bucket.arn}/*", aws_s3_bucket.codepipeline_bucket.arn ]
#   }
# }