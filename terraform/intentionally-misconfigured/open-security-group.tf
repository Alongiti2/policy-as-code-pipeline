# INTENTIONALLY MISCONFIGURED -- used to demonstrate the policy pipeline
# catching a real, common misconfiguration class. Do not deploy this.
#
# Misconfigurations present:
#   1. SSH (port 22) open to 0.0.0.0/0 (CKV_AWS_24 / CKV_AWS_260)
#   2. RDP (port 3389) open to 0.0.0.0/0 (CKV_AWS_25)
#   3. No description on ingress rules (CKV_AWS_23 -- best practice for audit)

resource "aws_security_group" "misconfigured_example" {
  name        = "misconfigured-sg-demo"
  description = "Intentionally misconfigured for policy pipeline demo -- do not deploy"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # MISCONFIGURATION: SSH open to the entire internet
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # MISCONFIGURATION: RDP open to the entire internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "intentionally-misconfigured -- do not deploy"
  }
}
