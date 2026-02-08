# Region AWS
variable "aws_region" {
  description = "AWS region for bootstrap resources"
  type        = string
  default     = "ap-southeast-1"
}

# Name S3 bucket for terraform state
variable "terraform_state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
}

# Name DynamoDB for terraform state
variable "terraform_state_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}