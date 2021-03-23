
resource "aws_instance" "server" {
  count                       = 3
  ami                         = lookup(var.ami, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = element(aws_subnet.SubnetPublic.*.id, count.index)
  vpc_security_group_ids      = [aws_security_group.Project_security_group_jenkins.id]
    key_name                    = var.ssh_key_name

##aws data#####################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data = element(data.template_file.consul_server.*.rendered, count.index)
###############################################################################

  tags = {
    Name          = "consul-server-${count.index + 1}"
	Environment = "Dev"
    consul_server = "true"
  }
}







 resource "aws_instance" "monitor" {
  count = 1
  ami           = lookup(var.ami, var.region)
  instance_type = "t2.micro"
  associate_public_ip_address = true
   subnet_id                   = element(aws_subnet.SubnetPublic.*.id, count.index)
   vpc_security_group_ids      = [aws_security_group.Project_security_group_jenkins.id]
   key_name                    = var.ssh_key_name
###aws date################################################################################ 
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data = element(data.template_cloudinit_config.monitor.*.rendered, count.index)
###########################################################################################

  tags = {
    Name = "monitor-${count.index + 1}"
	Environment = "Dev"
 }
}



locals {
  jenkins_default_name = "jenkins_3"
  jenkins_home = "/home/ubuntu/jenkins_home"
  jenkins_home_mount = "${local.jenkins_home}:/var/jenkins_home"
  docker_sock_mount = "/var/run/docker.sock:/var/run/docker.sock"
  java_opts = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
}

resource "aws_instance" "jenkins_server" {
  count = 1
  ami           = "ami-0f81b4beaa701de94"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.SubnetPublic[count.index].id
  vpc_security_group_ids      = [aws_security_group.Project_security_group_jenkins.id]
    key_name                    = var.ssh_key_name


  
 
###aws date################################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data = element(data.template_cloudinit_config.jenkins_server.*.rendered, count.index)
###########################################################################################

  tags = {
    Name = "server-jenkins-${count.index + 1}"
	Environment = "Dev"
  } 
}



resource "aws_instance" "jenkins_slaves" {
  count = 2
  ami           = lookup(var.ami, var.region)
  instance_type = "t2.micro"
  associate_public_ip_address = true
 subnet_id                   = aws_subnet.subnetPrivate[count.index].id
  vpc_security_group_ids      = [aws_security_group.Project_security_group_jenkins.id]
    key_name                    = var.ssh_key_name


  
###aws date################################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data = element(data.template_cloudinit_config.consul_client_jenkins_slave.*.rendered, count.index)
###########################################################################################

  tags = {
    Name = "jenkins-slave-${count.index + 1}"
	Environment = "Dev"
  } 
}



resource "aws_instance" "Mysql" {
  count = 1
  ami           = lookup(var.ami, var.region)
  instance_type = "t2.micro"
  associate_public_ip_address = true
 subnet_id                   = aws_subnet.subnetPrivate[count.index].id
  vpc_security_group_ids      = [aws_security_group.Project_security_group_jenkins.id]
    key_name                    = var.ssh_key_name


  
###aws date################################################################################
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  user_data = element(data.template_cloudinit_config.consul_client_Mysql.*.rendered, count.index)
###########################################################################################

  tags = {
    Name = "mysql-${count.index + 1}"
	Environment = "Dev"
  } 
}










