# INTENTIONALLY MISCONFIGURED -- used to demonstrate the policy pipeline
# catching a real, common misconfiguration class. Do not deploy this.
#
# Misconfigurations present:
#   1. Wildcard action + wildcard resource -- full admin equivalent
#      (CKV_AWS_1 / CKV_AWS_355 -- "no wildcards in IAM policy statements")
#   2. No condition restricting who/what can assume this policy

resource "aws_iam_policy" "misconfigured_example" {
  name        = "misconfigured-wildcard-policy-demo"
  description = "Intentionally misconfigured for policy pipeline demo -- do not deploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"   # MISCONFIGURATION: any action, on...
        Resource = "*"   # MISCONFIGURATION: ...any resource. This is full admin access.
      }
    ]
  })

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "intentionally-misconfigured -- do not deploy"
  }
}
