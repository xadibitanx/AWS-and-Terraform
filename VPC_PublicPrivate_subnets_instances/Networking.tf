#elb creation
resource "aws_elb" "lb" {
  name = "Myweb-elb"
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances                   = aws_instance.web_server.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups             = [aws_security_group.web-sg.id]
  subnets                     = aws_subnet.SUBNET_WEB.*.id
  tags = {
    Name = "lb"
  }
}
#
###################################################################################################################################################3
#network
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main"
  }
}



resource "aws_subnet" "SUBNET_WEB" {
  count             = length(var.web_subnet_list)
  availability_zone = var.az_list[count.index]
  cidr_block        = var.web_subnet_list[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    "Name" = "SUBNET_A"
  }
}
resource "aws_subnet" "SUBNET_DB" {
  count             = length(var.db_subnet_list_B)
  availability_zone = var.az_list[count.index]
  cidr_block        = var.db_subnet_list_B[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    "Name" = "SUBNET_B"
  }
}
############################################################################################3
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "Gateway"
  }
}
resource "aws_route_table" "route_all" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
resource "aws_route_table_association" "SUBNET_WEB" {
  count          = length(var.web_subnet_list)
  subnet_id      = aws_subnet.SUBNET_WEB.*.id[count.index]
  route_table_id = aws_route_table.route_all.id
}
resource "aws_eip" "SUBNET_WEB" {
  count = length(var.web_subnet_list)
  vpc   = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.web_subnet_list)
  allocation_id = aws_eip.SUBNET_WEB[count.index].id
  subnet_id     = aws_subnet.SUBNET_WEB.*.id[count.index]
  tags = {
    "Name" = "NatGateway"
  }


}

resource "aws_route_table" "SUBNET_DB" {
  count  = length(var.db_subnet_list_B)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.*.id[count.index]
  }
}
resource "aws_route_table_association" "SUBNET_DB" {
  count          = length(var.db_subnet_list_B)
  subnet_id      = aws_subnet.SUBNET_DB.*.id[count.index]
  route_table_id = aws_route_table.SUBNET_DB.*.id[count.index]
}
resource "aws_eip" "jumphost" {
  count    = length(var.db_subnet_list_B)
  instance = aws_instance.web_server.*.id[count.index]
  vpc      = true
}
######################################
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "security group for ansible servers"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "security group for ansible servers"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}