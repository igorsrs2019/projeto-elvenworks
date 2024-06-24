#output "id_vpc" {
#value =  aws_vpc.vpc_projeto.id
#}

output "securit_group_id" {
value = aws_security_group.sg_projeto.id
} 


output "subnet_privada1_id" {
    value  = aws_subnet.subnet-privada1.id
  
}

output "subnet_privada2_id" {
    value  = aws_subnet.subnet-privada2.id
  
}


output "keypair_name"{
 value = aws_key_pair.key_linux.key_name
}







