provider "aws" {
  # Regions AWS tempat resource bootstrap dibuat
  region = var.aws_region

  # Credential diambil dari:
  # - AWS CLI profile
  # - Environment variable
  # - Buka dari code
}