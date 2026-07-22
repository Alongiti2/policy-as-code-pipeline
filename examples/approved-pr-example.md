# Example: An Approved Pull Request

This walks through the same scenario as `blocked-pr-example.md`, but with the fixed Terraform from `terraform/compliant/`.

## What the PR contains

The same four resource types, each fixed:
- S3 bucket: private ACL, KMS encryption, versioning enabled, access logging enabled, public access block enabled
- Security group: SSH scoped to a specific trusted CIDR (not the internet), RDP rule removed entirely since it wasn't needed, egress scoped to HTTPS only, every rule has a description
- IAM policy: specific actions (`s3:GetObject`, `s3:ListBucket`) on a specific resource ARN, not `"*"`/`"*"`
- EBS volume: `encrypted = true`

## What happens in CI

```
Passed checks: 32, Failed checks: 0, Skipped checks: 0
```

See [`approved-pr-scan-output.txt`](./approved-pr-scan-output.txt) for the full, real output from running the same baseline config against this folder — zero failures.

## Why this matters as a portfolio artifact, not just a code sample

The point being demonstrated here isn't "I can write correct Terraform" — it's that the **same policy configuration, run against two versions of the same infrastructure, produces a clear pass/fail signal a team can act on automatically**. That's the actual mechanism that makes shift-left security work in practice: not a document telling engineers what good IaC looks like, but a gate that enforces it before merge, with specific enough feedback that fixing it doesn't require a security team member in the loop for every PR.
