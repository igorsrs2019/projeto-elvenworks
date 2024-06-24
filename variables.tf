variable "region" {
  default = "us-east-1"
  type    = string

}

variable "aws_profile" {
  default = "projeto-elvenworks"
  type    = string
}

#infra_subnet1_id = module.infrastructure.aws_subnet.subnet-publica1.id


#subnet_id = module.infrastructure.subnet_publica1_id

/*
variable "infra_vpc_id" {
  description = aws_vpc.id_vpc
}
variable "infra_subnet2_id" {
  description = aws_subnet.infra_subnet2_id
}


*/