provider "aws" {
  region                  = var.aws_region
  profile                 = "default"
  shared_credentials_file = "C:\\Users\\adida\\.aws"
}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
#key creation
resource "tls_private_key" "mafteah" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "mafteah" {
  key_name   = "mafteah"
  public_key = tls_private_key.mafteah.public_key_openssh
}