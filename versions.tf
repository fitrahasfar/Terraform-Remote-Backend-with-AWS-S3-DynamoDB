terraform {
  # Mengunci versi Terraform agar konsistem di semua developer & CI
  required_version = ">= 1.6.0"

  # Mengunci versi provider AWS
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}