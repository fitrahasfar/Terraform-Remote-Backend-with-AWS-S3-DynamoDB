# S3
resource "aws_s3_bucket" "terraform_state" {
  # Name bucket must be global and unik
  bucket = var.terraform_state_bucket_name

  # Tag for audit and billing
  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    # Enable versioning so that old state are not lost
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  # Prevent public bucket access
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # automatic encryption using AES256
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17" # Versi policy AWS

    Statement = [
      {
        # Statement 1 — HTTPS Required
        Sid    = "DenyInsecureTransport" # Policy rule identifier
        Effect = "Deny"                  # Explicitly deny the action

        Principal = "*"    # Applies to all users and roles
        Action    = "s3:*" # All action s3

        Resource = [
          aws_s3_bucket.terraform_state.arn,       # Bucket
          "${aws_s3_bucket.terraform_state.arn}/*" # Fill the bucket
        ]

        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        # Statement 2 — PROHIBIT delete terraform.tfstate
        Sid       = "DenyDeleteTerraformState"               # Policy rule identifier
        Effect    = "Deny"                                   # Explicitly deny the action
        Principal = "*"                                      # Applies to all users and roles
        Action    = "s3:DeleteObject"                        # Prevent deleting objects in S3
        Resource  = "${aws_s3_bucket.terraform_state.arn}/*" # Applies to all objects inside the bucket
      }
    ]
  })
}


# DynamoDB
resource "aws_dynamodb_table" "terraform_state_lock" {
  # Name table
  name = var.terraform_state_lock_table_name

  # Billing mode without planning capacity
  billing_mode = "PAY_PER_REQUEST"

  # Primary key for locking Terraform
  hash_key = "LockID"

  attribute {
    name = "LockID" # Name primary key
    type = "S"      # type data String
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

