# Example: A Blocked Pull Request

This walks through what happens when someone opens a PR containing the Terraform in `terraform/intentionally-misconfigured/`.

## What the PR contains

Four resources, each with a real, common misconfiguration:
- An S3 bucket with public-read ACL, no encryption, no versioning, no access logging, no public access block
- A security group with SSH and RDP open to `0.0.0.0/0`
- An IAM policy granting `Action: "*"` on `Resource: "*"` (full admin)
- An unencrypted EBS volume

## What happens in CI

The `policy-gate` job in `.github/workflows/policy-check.yml` runs Checkov against the PR's Terraform using `policies/checkov-baseline.yaml`. Since this fixture lives in `terraform/intentionally-misconfigured/` specifically to demonstrate the block (the actual merge-blocking gate scans `terraform/compliant/` in this repo's own CI — see the workflow file for why), running the same scan manually against this folder produces:

```
Passed checks: 8, Failed checks: 19, Skipped checks: 0
```

See [`blocked-pr-scan-output.txt`](./blocked-pr-scan-output.txt) for the full, real output — 19 specific findings, each naming the exact resource and file/line.

## What the PR author sees

A failed check status on the PR (via the GitHub Actions check run), plus the full findings list in the Actions log — specific enough to fix without needing to ask a security engineer what's wrong. For example:

```
Check: CKV_AWS_24: "Ensure no security groups allow ingress from 0.0.0.0:0 to port 22"
	FAILED for resource: aws_security_group.misconfigured_example
	File: /open-security-group.tf:9-38
```

## What fixes it

Compare `terraform/intentionally-misconfigured/open-security-group.tf` to `terraform/compliant/restricted-security-group.tf` — same resource, each misconfiguration fixed with an inline comment explaining the fix. This is the shift-left value proposition: the PR author gets specific, actionable feedback in the PR itself, before anything is ever deployed, rather than finding out about the open security group from a cloud security posture management (CSPM) alert after the fact.
