# Policy Library

This pipeline uses [Checkov](https://www.checkov.io/) for static analysis of Terraform, rather than hand-writing custom Rego/OPA policies from scratch. The reasoning: Checkov's built-in policy set already encodes hundreds of well-maintained checks mapped to standard frameworks, and reinventing that (badly, as a portfolio project) would demonstrate less real-world judgment than knowing when to use a mature tool versus rolling your own.

`checkov-baseline.yaml` in this folder is the actual policy configuration used by the CI pipeline (`.github/workflows/policy-check.yml`). It is not the default Checkov config — it's a deliberately scoped baseline with every exclusion documented and justified inline.

## Why a scoped baseline instead of "enable everything"

Running every Checkov check with zero exclusions produces a pipeline that fails on legitimate architectural choices (e.g. "no cross-region replication configured" isn't a security bug for every workload) — teams learn to ignore red CI, which defeats the purpose of the gate. A credible policy pipeline is one where **every failure means something the team agrees is actually wrong**. See `checkov-baseline.yaml` for the specific checks scoped out and why.

## Mapping to common frameworks

A sample of the checks enforced by this baseline, mapped to CIS Benchmarks and NIST 800-53 for teams that need to justify a control to an auditor:

| Checkov Check | What it enforces | CIS AWS Benchmark | NIST 800-53 |
|---|---|---|---|
| CKV_AWS_20 | No public-read ACL on S3 buckets | CIS 2.1.5 | AC-3, SC-7 |
| CKV2_AWS_6 | S3 Public Access Block enabled | CIS 2.1.5 | AC-3, SC-7 |
| CKV_AWS_18 | S3 access logging enabled | CIS 3.6 | AU-2, AU-12 |
| CKV_AWS_21 | S3 versioning enabled | — | CP-9, SI-12 |
| CKV_AWS_24 | No SSH open to 0.0.0.0/0 | CIS 5.2 | AC-4, SC-7 |
| CKV_AWS_25 | No RDP open to 0.0.0.0/0 | CIS 5.3 | AC-4, SC-7 |
| CKV_AWS_23 | Security group rules have descriptions | — | CM-6 (audit trail) |
| CKV_AWS_3 | EBS volumes encrypted at rest | CIS 2.2.1 | SC-28 |
| CKV_AWS_63 | No IAM policy allows `"*"` as Action | CIS 1.16 | AC-6 (least privilege) |
| CKV_AWS_355 | No IAM policy allows `"*"` as Resource | CIS 1.16 | AC-6 (least privilege) |
| CKV_AWS_62 | No full-admin IAM policies | CIS 1.16 | AC-6 (least privilege) |

## How to actually try this

```bash
pip install checkov

# See the gate fail (this is the intentionally-broken fixture)
checkov -d terraform/intentionally-misconfigured --config-file policies/checkov-baseline.yaml

# See the gate pass (this is the fixed version of the same resources)
checkov -d terraform/compliant --config-file policies/checkov-baseline.yaml
```

Real output from both runs, captured directly from this baseline config, is saved in [`examples/blocked-pr-scan-output.txt`](../examples/blocked-pr-scan-output.txt) and [`examples/approved-pr-scan-output.txt`](../examples/approved-pr-scan-output.txt) — not fabricated sample output, an actual scan against the Terraform in this repo.
