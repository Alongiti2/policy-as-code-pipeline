# COMPLIANT VERSION -- same resource as
# ../intentionally-misconfigured/unencrypted-ebs.tf, with encryption enabled.

resource "aws_ebs_volume" "compliant_example" {
  availability_zone = "us-west-2a"
  size              = 10
  encrypted         = true # FIXED: data at rest is encrypted

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "compliant -- passes policy checks"
  }
}
