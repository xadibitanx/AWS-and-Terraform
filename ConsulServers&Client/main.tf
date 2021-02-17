provider "aws" {
  region                  = var.region
  profile                 = "default"
  shared_credentials_file = "C:\\path\\.aws"
}

resource "aws_instance" "server_consul" {
  count                       = 3
  ami                         = lookup(var.ami, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.consol-sgment.id]
  key_name                    = "MYconsolKey"

  iam_instance_profile = aws_iam_instance_profile.consul-join.name

  user_data = element(data.template_file.consul_server.*.rendered, count.index)

  tags = {
    Name          = "consul-server-${count.index + 1}"
    consul_server = "true"
  }
}



 resource "aws_instance" "monitor" {
  count = 1

  ami           = lookup(var.ami, var.region)
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.consol-sgment.id]
  key_name               = "MYconsolKey"




  iam_instance_profile = aws_iam_instance_profile.consul-join.name

  user_data = element(data.template_cloudinit_config.consul_client.*.rendered, count.index)


  tags = {
    Name = "monitor-${count.index + 1}"
 }
}



