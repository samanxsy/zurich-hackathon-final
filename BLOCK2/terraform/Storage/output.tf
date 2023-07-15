output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.image_bucket.arn
}

output "log_bucket_id" {
  value = aws_s3_bucket.log_bucket.id
}

output "db_table_name" {
  value = aws_dynamodb_table.webapp_table.name
}
