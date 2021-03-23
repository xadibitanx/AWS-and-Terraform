
resource "aws_route53_zone" "private" {
  name = "opss_pro.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "consul" { 
 
  zone_id = aws_route53_zone.private.zone_id
  name    = "consul-servers"
  type     = "A"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "consul"
  records        = aws_instance.server.*.private_ip
  
}
resource "aws_route53_record" "jenkins" { 
 
  zone_id = aws_route53_zone.private.zone_id
  name    = "jenkin-server"
  type     = "A"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "jenkins"
  records        = aws_instance.jenkins_server.*.private_ip
}
resource "aws_route53_record" "jenkins_slaves" { 
 
  zone_id = aws_route53_zone.private.zone_id
  name    = "jenkin-server"
  type     = "A"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "jenkins_server"
  records        = aws_instance.jenkins_slaves.*.private_ip
}

resource "aws_route53_record" "Monitor" { 
 
  zone_id = aws_route53_zone.private.zone_id
  name    = "Monitor-server"
  type     = "A"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "monitor_server"
  records        = aws_instance.monitor.*.private_ip
  
  
  
}

