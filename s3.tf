# S3 Bucket
resource "aws_s3_bucket" "deham37_bucket" {
  bucket = "deham37-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "deham37-bucket"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "deham37_bucket" {
  bucket = aws_s3_bucket.deham37_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "deham37_bucket" {
  bucket = aws_s3_bucket.deham37_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "deham37_bucket" {
  bucket = aws_s3_bucket.deham37_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Data source to get the current AWS account ID for unique bucket naming
data "aws_caller_identity" "current" {}
