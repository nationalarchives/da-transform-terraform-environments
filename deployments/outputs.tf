output "tdr-queue-arn" {
  value = module.tdr_sqs_in_queue.tdr_sqs_queue_arn
  description = "SQS Queue ARN for TDR Input"
}
