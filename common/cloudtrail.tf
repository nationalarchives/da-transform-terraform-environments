resource "aws_s3_bucket" "log_bucket" {
  acl    = "log-delivery-write"
  bucket = "${local.bucket_name}-logs"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = local.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  s3_key_prefix                 = local.cloudtrail_prefix
  include_global_service_events = false
  is_multi_region_trail         = false
  #cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  #cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}${var.log_stream_wildcard}"
  enable_log_file_validation = true
  kms_key_id                 = aws_s3_bucket.log_bucket.server_side_encryption_configuration.kms_key_id

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