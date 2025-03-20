output "bucket_arn" {
  value       = aws_s3_bucket.example.arn
  description = "The ARN of the S3 bucket"
}

output "bucket_id" {
  value       = aws_s3_bucket.example.id
  description = "The ID (name) of the S3 bucket"
}