resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_versioning" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${local.bucket_name}-logs"
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
  kms_key_id                 = aws_kms_key.mykey.arn

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

/*
resource "aws_iam_role" "cloudtrail_role" {
  name               = "${upper(var.project)}CloudTrail${title(local.environment)}"
  assume_role_policy = data.template_file.cloudtrail_assume_role_policy.rendered
}
*/