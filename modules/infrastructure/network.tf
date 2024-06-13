//Criacao de VPC
resource "aws_vpc" "vpc_projeto" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name,
    Terraformed = "true"    
  }
}

// Criacao das subnets

resource "aws_subnet" "subnet-publica1" {
    vpc_id = aws_vpc.vpc_projeto.id
    cidr_block = var.subnet_publica1_cidr
    availability_zone = var.subnet_region-a
    tags = {
    Name = var.subnet_publica1_name,
    Terraformed = "true"    
  }
    depends_on = [aws_vpc.vpc_projeto]
    
}

resource "aws_subnet" "subnet-publica2" {
    vpc_id = aws_vpc.vpc_projeto.id
    cidr_block = var.subnet_publica2_cidr
    availability_zone = var.subnet_region-b
    tags = {
    Name = var.subnet_publica2_name,
    Terraformed = "true"    
  }

    depends_on = [aws_vpc.vpc_projeto]
}

resource "aws_subnet" "subnet-privada1" {
    vpc_id = aws_vpc.vpc_projeto.id
    cidr_block = var.subnet_privada1_cidr
    availability_zone = var.subnet_region-c
    tags = {
    Name = var.subnet_privada1_name,
    Terraformed = "true"    
  }
depends_on = [aws_vpc.vpc_projeto]
    
}


resource "aws_subnet" "subnet-privada2" {
    vpc_id = aws_vpc.vpc_projeto.id
    cidr_block = var.subnet_privada2_cidr
    availability_zone = var.subnet_region-d
    tags = {
    Name = var.subnet_privada2_name,
    Terraformed = "true"    
  }
depends_on = [aws_vpc.vpc_projeto]
    
}


// Criacao do Internet Gateway

resource "aws_internet_gateway" "internet-gw" {
    vpc_id = aws_vpc.vpc_projeto.id
    tags = {
      Name = "Internet-gw"
      Terraformed = "True"  
    }

    depends_on = [aws_vpc.vpc_projeto]
  
}

//Criacao de EIPS

resource "aws_eip" "eip_nat_gw_1" {
domain = "vpc"
   tags = {
    Terraformed = "true"


   }
     depends_on = [aws_vpc.vpc_projeto, aws_internet_gateway.internet-gw]

}

resource "aws_eip" "eip_nat_gw_2" {
domain = "vpc"
   tags = {
    Terraformed = "true"


   }
   depends_on = [aws_vpc.vpc_projeto, aws_internet_gateway.internet-gw]

}

// Criacao dos Nats Gateways

resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip_nat_gw_1.id
  subnet_id     = aws_subnet.subnet-publica1.id

  tags = {
    Terraformed = "true"
  }

  depends_on = [aws_internet_gateway.internet-gw, aws_eip.eip_nat_gw_1]
}

resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip_nat_gw_2.id
  subnet_id     = aws_subnet.subnet-publica2.id

  tags = {
    Terraformed = "true"
  }

  depends_on = [aws_internet_gateway.internet-gw, aws_eip.eip_nat_gw_2]
}



// Criacao das tabelas de roteamento

resource "aws_route_table" "publica1"{
    vpc_id = aws_vpc.vpc_projeto.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gw.id

    }
    tags = {
        Name = "rtb-publica1"
    }

depends_on = [aws_internet_gateway.internet-gw, aws_vpc.vpc_projeto]

}
  
  resource "aws_route_table" "publica2"{
    vpc_id = aws_vpc.vpc_projeto.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gw.id

    }
    tags = {
        Name = "rtb-publica2"
    }


    depends_on = [aws_internet_gateway.internet-gw, aws_vpc.vpc_projeto]
}

resource "aws_route_table" "privada1"{
    vpc_id = aws_vpc.vpc_projeto.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gateway-1.id

    }
    tags = {
        Name = "rtb-privada1"
    }

    depends_on = [aws_internet_gateway.internet-gw, aws_vpc.vpc_projeto]
}

resource "aws_route_table" "privada2"{
    vpc_id = aws_vpc.vpc_projeto.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gateway-2.id

    }
    tags = {
        Name = "rtb-privada2"
    }
    depends_on = [aws_internet_gateway.internet-gw, aws_vpc.vpc_projeto]
}

// Criar as associacoes entre as tabelas de roteamento e as subnets 

resource "aws_route_table_association" "publica1" {
    subnet_id = aws_subnet.subnet-publica1.id
    route_table_id = aws_route_table.publica1.id
  
}

resource "aws_route_table_association" "publica2" {
    subnet_id = aws_subnet.subnet-publica2.id
    route_table_id = aws_route_table.publica2.id
  
}


resource "aws_route_table_association" "privada1" {
    subnet_id = aws_subnet.subnet-privada1.id
    route_table_id = aws_route_table.privada1.id
  
}

resource "aws_route_table_association" "privada2" {
    subnet_id = aws_subnet.subnet-privada2.id
    route_table_id = aws_route_table.privada2.id
  
}

// Criacao keypair
resource "aws_key_pair" "key_linux" {
  key_name   = "key_linux"
  public_key = tls_private_key.rsa-4096.public_key_openssh
  
  }
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key_linux_private" {
  content  = tls_private_key.rsa-4096.private_key_pem
  filename = "modules/infrastructure/key_linux_private"
}