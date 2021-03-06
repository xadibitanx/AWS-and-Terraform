variable "region" {
  default = "us-east-2"
}


variable "instance_count" {
  default = "2"
}
##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

##################################################################################
# DATA
##################################################################################



############### NETWORKING ################


#This uses the default VPC.  It WILL NOT delete it on destroy.

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "allow_ssh" {
  name        = "nginx_demo"
  description = "Allow ports for nginx demo"
  vpc_id      = "vpc-01c8626a"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
############  THE INSTANCE  ##########


resource "aws_instance" "nginx" {
  ami                    = "ami-07efac79022b86107"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = "TerraformNginx"
  count                  = "2"
  
########## VOLUME BLOCK ##############

  ebs_block_device {
    volume_size = "10"
    volume_type = "gp2"
    device_name = "/dev/sdh"
  }

########### TAG ######################  

  tags = {
    Name        = "nginx_web"
  }

###### Connection & Commands ########

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path_nginx)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -i apt  install nginx -y",
      "sudo -i service nginx start",
      "sudo -i service nginx restart",
    ]
  }
}


################ OUTPUT ####################

output "instance_count" {
  value = aws_instance.nginx.*.public_ip
}

################ Variable ##################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "private_key_path_nginx" {}