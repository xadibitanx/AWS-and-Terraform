#network
resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "SubnetPublic" {
  count             = length(var.public_subnet_list)
  availability_zone = var.az_list[count.index]
  cidr_block        = var.public_subnet_list[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    "Name" = "SubnetPublic"
  }
}


resource "aws_subnet" "subnetPrivate" {
  count             = length(var.private_subnet_list)
  availability_zone = var.az_list[count.index]
  cidr_block        = var.private_subnet_list[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    "Name" = "SUBNET_B"
  }
}


##################################################
#elb creation
resource "aws_elb" "lb" {
  name = "Myweb-elb"



  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 8080
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }
  instances                   = aws_instance.jenkins_server.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups             = [aws_security_group.Project_security_group.id]
  subnets                     = aws_subnet.SubnetPublic.*.id
  tags = {
    Name = "lb"
  }
}





resource "aws_eip" "SubnetPublic" {
  count = length(var.public_subnet_list)
  vpc   = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnet_list)
  allocation_id = aws_eip.SubnetPublic[count.index].id
  subnet_id     = aws_subnet.SubnetPublic.*.id[count.index]
  tags = {
    "Name" = "NatGateway"
  }


}

resource "aws_route_table" "subnetPrivate" {
  count  = length(var.private_subnet_list)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.*.id[count.index]
  }
}
resource "aws_route_table_association" "subnetPrivate" {
  count          = length(var.private_subnet_list)
  subnet_id      = aws_subnet.subnetPrivate.*.id[count.index]
  route_table_id = aws_route_table.subnetPrivate.*.id[count.index]
}



###########################################


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
resource "aws_route_table_association" "SubnetPublic" {
  count          = length(var.public_subnet_list)
  subnet_id      = aws_subnet.SubnetPublic.*.id[count.index]
  route_table_id = aws_route_table.route_all.id
}

