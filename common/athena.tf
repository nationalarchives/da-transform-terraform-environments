resource "aws_athena_database" "data" {
  name   = "tre_audit_data"
  bucket = aws_s3_bucket.log_bucket.bucket

  encryption_configuration {
    encryption_option = "SSE_KMS"
    kms_key           = aws_kms_key.cloudtrail_key.id
  }
}

resource "aws_athena_workgroup" "workgroup" {
  name = "tre_audit_workgroup"

  configuration {
    result_configuration {

      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn       = aws_kms_key.cloudtrail_key.arn
      }

      output_location = "s3://${aws_s3_bucket.log_bucket.bucket}/athena/results/"
    }
  }
}

resource "aws_athena_named_query" "query" {
  name      = "test_query"
  workgroup = aws_athena_workgroup.workgroup.*.id[0]
  database  = aws_athena_database.data.*.name[0]
  query     = "SELECT * FROM ${aws_athena_database.data.name} limit 10;"
}