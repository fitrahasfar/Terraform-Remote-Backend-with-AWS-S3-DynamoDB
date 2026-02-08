# Terraform Remote Backend with AWS S3 & DynamoDB

## Project Overview

This project demonstrates how to configure **Terraform Remote Backend**
using **AWS S3** and **DynamoDB**.

The purpose of this setup is to ensure Terraform state is:
- Stored remotely
- Secure
- Safe for team collaboration
- Ready for automation and CI/CD pipelines

This repository does **not** provision application infrastructure.
It focuses only on **Terraform state management best practices**.

---

## Remote Backend Configuration

Terraform state is stored in:
- **Amazon S3** → for persistent state storage
- **Amazon DynamoDB** → for state locking

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-production-243111"
    key    = "global/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "terraform-state-production-243111-lock"
    encrypt        = true
  }
}

Why Remote Backend Is Important

Terraform state may contain sensitive data such as:

Resource IDs

Internal IP addresses

ARNs

Metadata

Using a remote backend provides:

Protection against state loss

Prevention of concurrent terraform apply

Safer collaboration for teams

Terraform Workflow Explanation
terraform init

Initializes the working directory

Downloads required providers

Configures the remote backend

Migrates local state to remote state (if exists)

This command must be run first.

terraform fmt

Automatically formats Terraform files

Keeps code clean and readable

Enforces standard style

terraform validate

Checks Terraform configuration syntax

Ensures the configuration is logically valid

Does not contact AWS

terraform plan

Shows what Terraform will change

No resources are created or modified

Used to review changes before applying

terraform apply

Applies the planned changes

Creates or updates resources

Uses DynamoDB to prevent concurrent execution

terraform destroy (Restricted)

Destroys managed infrastructure

Should be limited to specific users or environments

Not recommended for production without safeguards

Notes

Local terraform.tfstate is no longer used

State is fully managed in S3 after initialization

Never edit the Terraform state manually

Always use the correct AWS credentials and environment

Intended Usage

This project is suitable for:

Learning Terraform remote backend

Production-ready Terraform setup

Team-based infrastructure workflows

CI/CD pipeline integration
