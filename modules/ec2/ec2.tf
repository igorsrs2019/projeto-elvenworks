
resource "aws_instance" "ec2" {
  ami                     = "ami-08a0d1e16fc3f61ea"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.subnet-privada1.id
  vpc_security_group_ids = aws_security_group.subnet_privada1_name.id
  key_name = data.output.name_key_pair.name
  
  depends_on = [aws_key_pair.key_linux, aws_vpc.vpc_projeto ]
}

resource "aws_security_group" "sg_projeto" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = vpc_name.vpc_projeto.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = vpc_name.vpc_projeto.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = vpc_name.vpc_projeto.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = vpc_name.vpc_projeto.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

/*resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}*/



/*resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}*/