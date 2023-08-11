resource "aws_route53_zone" "private_zone" {
  name = "demo-radarhack.internal"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "example_a_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "my-instance"
  type    = "A"
  ttl     = "300"
  
  records = [
    "11.12.13.14"  # Replace with the IP address you want the A record to point to
  ]
}

resource "aws_security_group" "endpoints-sg" {
  name        = "allow_custom_endpoints_r53"
  description = "endpoints sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_custom"
  }
}

resource "aws_route53_resolver_endpoint" "inbound_ep" {
  name      = "inbound_ep"
  direction = "INBOUND"

 security_group_ids = [
    aws_security_group.endpoints-sg.id,
    aws_security_group.endpoints-sg.id,
  ]

  ip_address {
    subnet_id = aws_subnet.PrivateSubnet1.id
  }

  ip_address {
    subnet_id = aws_subnet.HASyncSubnet1.id
  }

  tags = {
    Environment = "${var.prefix}-inbound-ep"
  }
}

resource "aws_route53_resolver_endpoint" "outbound_ep" {
  name      = "outbound_ep"
  direction = "OUTBOUND"

 security_group_ids = [
    aws_security_group.endpoints-sg.id,
    aws_security_group.endpoints-sg.id,
  ]

  ip_address {
    subnet_id = aws_subnet.PrivateSubnet1.id
  }

  ip_address {
    subnet_id = aws_subnet.HASyncSubnet1.id
  }

  tags = {
    Environment = "${var.prefix}-inbound-ep"
  }
}


resource "aws_route53_resolver_rule" "private_r53zone_access" {
  domain_name = "demo-radarhack.internal"
  name = "${var.prefix}-private_r53zone_access"
  rule_type   = "SYSTEM"
}


resource "aws_route53_resolver_rule" "radarhacker" {
  domain_name          = "radarhacker.com."
  name                 = "${var.prefix}-radarhacker"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound_ep.id
 
  target_ip {
    ip = "173.245.59.41"
      }
  target_ip {
    ip = "173.245.58.51"
      }
}

resource "aws_route53_resolver_rule_association" "example" {
  resolver_rule_id = aws_route53_resolver_rule.radarhacker.id
  vpc_id           = aws_vpc.main.id
}