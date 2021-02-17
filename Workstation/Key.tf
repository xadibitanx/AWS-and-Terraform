
resource "tls_private_key" "WorkStation" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "WorkStation" {
  key_name   = "WorkStation"
  public_key = tls_private_key.WorkStation.public_key_openssh
}

resource "local_file" "WorkStation" {
  sensitive_content = tls_private_key.WorkStation.private_key_pem
  filename          = "WorkStation.pem"
}

