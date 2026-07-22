# COMPLIANT VERSION -- same resource as
# ../intentionally-misconfigured/s3-public-bucket.tf, with every
# misconfiguration fixed. This is what a passing pull request looks like.

resource "aws_s3_bucket" "compliant_example" {
  bucket = "example-compliant-bucket-demo"

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "compliant -- passes policy checks"
  }
}

resource "aws_s3_bucket_acl" "compliant_example" {
  bucket = aws_s3_bucket.compliant_example.id
  acl    = "private" # FIXED: no public access via ACL
}

resource "aws_s3_bucket_server_side_encryption_configuration" "compliant_example" {
  bucket = aws_s3_bucket.compliant_example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms" # FIXED: encryption at rest enabled
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "compliant_example" {
  bucket = aws_s3_bucket.compliant_example.id

  versioning_configuration {
    status = "Enabled" # FIXED: protected against accidental/malicious deletion
  }
}

resource "aws_s3_bucket_logging" "compliant_example" {
  bucket = aws_s3_bucket.compliant_example.id

  target_bucket = aws_s3_bucket.compliant_example.id # in production, use a separate logging bucket
  target_prefix = "access-logs/"                       # FIXED: audit trail of access enabled
}

resource "aws_s3_bucket_public_access_block" "compliant_example" {
  bucket = aws_s3_bucket.compliant_example.id

  block_public_acls       = true # FIXED: public access blocked at the bucket level
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
