# COMPLIANT VERSION -- same resource as
# ../intentionally-misconfigured/open-security-group.tf, with every
# misconfiguration fixed.

variable "trusted_admin_cidr" {
  description = "CIDR block for administrative access (e.g. corporate VPN or bastion range) -- never 0.0.0.0/0"
  type        = string
  default     = "10.0.0.0/16" # replace with your actual trusted range
}

resource "aws_security_group" "compliant_example" {
  name        = "compliant-sg-demo"
  description = "Compliant security group -- passes policy checks"

  ingress {
    description = "SSH from trusted admin range only" # FIXED: added description
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.trusted_admin_cidr] # FIXED: scoped to a specific trusted range, not the internet
  }

  # RDP ingress rule removed entirely -- FIXED: this workload doesn't need
  # RDP access at all; the misconfigured version opened a port that
  # wasn't even required, which is its own finding worth calling out.

  egress {
    description = "Outbound to package repositories and required services"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # FIXED: egress scoped to HTTPS only, not all ports/protocols
  }

  tags = {
    Purpose = "policy-pipeline-demo"
    Note    = "compliant -- passes policy checks"
  }
}
