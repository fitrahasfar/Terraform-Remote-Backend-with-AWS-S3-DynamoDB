terraform {
  backend "s3" {
    bucket         = "terraform-state-production-243111"      # S3 bucket where Terraform state file is stored
    key            = "global/terraform.tfstate"               # Path and name of the state file inside the S3 bucket
    region         = "ap-southeast-1"                         # AWS region where the S3 bucket and DynamoDB table exist
    dynamodb_table = "terraform-state-production-243111-lock" # DynamoDB table used for state locking to prevent concurrent runs
    encrypt        = true                                     # Enable server-side encryption for the Terraform state file
  }
}