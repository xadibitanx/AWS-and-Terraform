
locals {
  cluster_name = "opsschool-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}




resource "aws_instance" "server" {
  count                       = 3
  ami                         = lookup(var.ami, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.SubnetPublic[count.index].id
  vpc_security_group_ids      = [aws_security_group.Project_security_group.id]
  key_name                    = aws_key_pair.MasterKeyStone.key_name

  ##aws data#####################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data            = element(data.template_file.consul_server.*.rendered, count.index)
  ###############################################################################

  tags = {
    Name          = "consul-server-${count.index + 1}"
    consul_server = "true"
  }
}








resource "aws_instance" "jenkins_server" {
  count                       = 1
  ami                         = lookup(var.ami, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.SubnetPublic[count.index].id
  vpc_security_group_ids      = [aws_security_group.Project_security_group.id]
  key_name                    = aws_key_pair.MasterKeyStone.key_name




  ###aws date################################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data            = element(data.template_cloudinit_config.jenkins_server.*.rendered, count.index)
  ###########################################################################################

  tags = {
    Name = "server-jenkins-${count.index + 1}"
  }
}



resource "aws_instance" "jenkins_slaves" {
  count                       = 2
  ami                         = lookup(var.ami, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.SubnetPublic[count.index].id
  vpc_security_group_ids      = [aws_security_group.Project_security_group.id]
  key_name                    = aws_key_pair.MasterKeyStone.key_name



  ###aws date################################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data            = element(data.template_cloudinit_config.consul_client_ssh.*.rendered, count.index)
  ###########################################################################################

  tags = {
    Name = "jenkins-node${count.index + 1}"
  }
}











