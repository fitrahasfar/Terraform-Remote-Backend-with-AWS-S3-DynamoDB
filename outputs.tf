output "terraform_state_bucket_name" {
  description = "S3 bucked used for Terraform remote state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_lock_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}