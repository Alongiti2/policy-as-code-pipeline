# INTENTIONALLY MISCONFIGURED -- used to demonstrate the policy pipeline
# catching a real, common misconfiguration class. Do not deploy this.
#
# Misconfiguration present:
#   1. EBS volume with encryption explicitly disabled (CKV_AWS_3)

resource "aws_ebs_volume" "misconfigured_example" {
  availability_zone = "us-west-2a"
  size              = 10
  encrypted         = false # MISCONFIGURATION: data at rest is unencrypted

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "intentionally-misconfigured -- do not deploy"
  }
}
