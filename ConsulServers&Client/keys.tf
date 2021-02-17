resource "tls_private_key" "MYconsolKey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "MYconsolKey" {
  key_name   = "MYconsolKey"
  public_key = tls_private_key.MYconsolKey.public_key_openssh
}

resource "local_file" "MYconsolKey" {
  sensitive_content = tls_private_key.MYconsolKey.private_key_pem
  filename          = "MYconsolKey.pem"
}

