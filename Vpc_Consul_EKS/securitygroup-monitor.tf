resource "aws_security_group" "Project_security_group_monitor" {
  name        = "Project_security_group_monitor"
  description = "security group for Project servers"
  vpc_id      = aws_vpc.main.id
    egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside the security group"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


    ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow UI from world"
  }

      ingress {
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
        ingress {
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = ["${data.http.myip.body}/32"]
  }
          ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["${data.http.myip.body}/32"]
  }
}


data "http" "myip" {
  url = "http://ifconfig.me"
}