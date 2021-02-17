
resource "aws_instance" "db_server" {
  count                       = length(var.web_subnet_list)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.SUBNET_DB[count.index].id
  vpc_security_group_ids      = [aws_security_group.db-sg.id]
  key_name                    = aws_key_pair.webDBkey.key_name
  tags = {
    Name = "db_server${count.index}"
  }
}

resource "aws_instance" "web_server" {
  count                       = length(var.web_subnet_list)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.SUBNET_WEB[count.index].id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  key_name                    = aws_key_pair.webDBkey.key_name
  tags = {
    Name = "web_server${count.index}"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.webDBkey.private_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      "sudo -i apt  install nginx -y",
      "sudo -i service nginx start",
      "sudo -i sed -i 's/Welcome to nginx!/hello from myself!/g' /var/www/html/index.nginx-debian.html",
      "sudo -i service nginx restart",
    ]
  }
}









