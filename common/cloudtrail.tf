resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cloudtrail_key.id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.log_bucket]

  bucket = aws_s3_bucket.log_bucket.bucket

  rule {
    id = "config"

    filter {
      prefix = local.bucket_prefix
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {

  bucket                  = aws_s3_bucket.log_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${local.bucket_name}-logs"
  depends_on = [
    aws_kms_key.cloudtrail_key
  ]
}

resource "aws_s3_bucket_policy" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.log_bucket.bucket}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.log_bucket.bucket}/${local.bucket_prefix}/AWSLogs/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control",
                    "AWS:SourceArn" : "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.mgmt.account_id}:trail/${local.cloudtrail_name}",
                    "AWS:SourceArn" : "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.nonprod.account_id}:trail/${local.cloudtrail_name}"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_kms_key" "cloudtrail_key" {
  description         = "This key is used to encrypt cloudtrail data and S3 objetcs"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms.json
  multi_region        = true
}

resource "aws_kms_alias" "cloudtrail_key" {
  name          = "alias/da-transform-key-alias"
  target_key_id = aws_kms_key.cloudtrail_key.key_id
}

# AWS Cloudtrail for AWS management account
resource "aws_cloudtrail" "cloudtrail" {
  name                          = local.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  s3_key_prefix                 = local.bucket_prefix
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail_key.arn

  depends_on = [
    aws_s3_bucket_policy.log_bucket,
    aws_kms_key.cloudtrail_key
  ]

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

# AWS Cloudtrail for AWS non-prod account
resource "aws_cloudtrail" "cloudtrail_non-prod" {
  provider                      = aws.nonprod
  name                          = local.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  s3_key_prefix                 = local.bucket_prefix
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail_key.arn

  depends_on = [
    aws_s3_bucket_policy.log_bucket,
    aws_kms_key.cloudtrail_key
  ]

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}
