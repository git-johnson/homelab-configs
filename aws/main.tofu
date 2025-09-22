terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket = "andrewdoesinfra-homelab-state"
        key   = "aws/terraform.tfstate"
        region = "us-east-2"
    }
}

# S3 bucket for Restic backups
resource "aws_s3_bucket" "r640-backup" {
    bucket = "adi-r640-restic-backups"
}

resource "aws_s3_bucket_versioning" "r640-backup" {
    bucket = aws_s3_bucket.r640-backup.id
    versioning_configuration {
        status = "Enabled"
    }
}