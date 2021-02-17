provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_security_group" "WorkStation" {

  description = "Allow WorkStation inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    // -1 means all
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}


resource "aws_instance" "WorkStation_server" {

  ami                         = "ami-011025cab7de3bd7e"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.WorkStation.key_name
  security_groups             = ["default", aws_security_group.WorkStation.name]
  associate_public_ip_address = true

  connection {
    host        = aws_instance.WorkStation_server.public_ip
    user        = "ubuntu"
    private_key = file("WorkStation_ec2_key")
  }
  tags = {
    Name = "WorkStation Server"
  }
}