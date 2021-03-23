resource "tls_private_key" "MasterKeyStone" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "MasterKeyStone" {
  key_name   = "MasterKeyStone"
  public_key = tls_private_key.MasterKeyStone.public_key_openssh
}

resource "local_file" "MasterKeyStone" {
  sensitive_content = tls_private_key.MasterKeyStone.private_key_pem
  filename          = "MasterKeyStone.pem"
}
