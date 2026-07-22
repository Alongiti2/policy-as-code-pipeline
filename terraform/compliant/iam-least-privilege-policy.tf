# COMPLIANT VERSION -- same resource as
# ../intentionally-misconfigured/iam-wildcard-policy.tf, with the
# wildcard actions/resources replaced by a scoped, least-privilege policy.

resource "aws_iam_policy" "compliant_example" {
  name        = "compliant-least-privilege-policy-demo"
  description = "Compliant IAM policy -- passes policy checks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadOnlyS3AccessToSpecificBucket"
        Effect = "Allow"
        Action = [ # FIXED: specific actions, not "*"
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [ # FIXED: specific resource ARN, not "*"
          "arn:aws:s3:::example-compliant-bucket-demo",
          "arn:aws:s3:::example-compliant-bucket-demo/*"
        ]
      }
    ]
  })

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "compliant -- passes policy checks"
  }
}
