# INTENTIONALLY MISCONFIGURED -- used to demonstrate the policy pipeline
# catching a real, common misconfiguration class. Do not deploy this.
#
# Misconfigurations present (each maps to a Checkov check ID -- see
# policies/README.md for the full mapping):
#   1. Public read ACL on the bucket (CKV_AWS_20 / CKV_AWS_54)
#   2. No default encryption configured (CKV_AWS_19 / CKV2_AWS_67)
#   3. No versioning enabled (CKV_AWS_21)
#   4. No access logging configured (CKV_AWS_18)
#   5. No public access block (CKV2_AWS_6)

resource "aws_s3_bucket" "misconfigured_example" {
  bucket = "example-misconfigured-bucket-demo"

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "intentionally-misconfigured -- do not deploy"
  }
}

resource "aws_s3_bucket_acl" "misconfigured_example" {
  bucket = aws_s3_bucket.misconfigured_example.id
  acl    = "public-read" # MISCONFIGURATION: bucket data readable by anyone
}

# No aws_s3_bucket_server_side_encryption_configuration resource --
# MISCONFIGURATION: data at rest is unencrypted.

# No aws_s3_bucket_versioning resource --
# MISCONFIGURATION: no protection against accidental/malicious deletion.

# No aws_s3_bucket_logging resource --
# MISCONFIGURATION: no audit trail of access to this bucket.

# No aws_s3_bucket_public_access_block resource --
# MISCONFIGURATION: nothing prevents the bucket from being made public
# even if the ACL above were fixed later.
