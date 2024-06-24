

// Criacao da primeira EC2
resource "aws_instance" "instance_1" {
  ami                     = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04 LTS
  instance_type           = "t2.micro" 
  iam_instance_profile = "Role_SSM"
  subnet_id = var.infra-subnet_privada1_id
  vpc_security_group_ids = [var.infra-sg_id]
  key_name = var.infra-keypair_name
  associate_public_ip_address = false

  user_data = <<-EOF
          #!/bin/bash
          sudo apt update && sudo apt install curl ansible unzip -y 
          cd /tmp
          wget https://executaveis2024.s3.amazonaws.com/ansible.zip
          unzip ansible.zip
          sudo ansible-playbook wordpress.yml
          EOF
   
   tags = {
        Name = "Server_Wordpress"
    }

  
  depends_on = [var.infra-subnet_privada1_id]
}



  output "instance_1_ip" {
  value = aws_instance.instance_1.public_ip
 }


// // Criacao da segunda EC2

resource "aws_instance" "instance_2" {
  ami                     = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04 LTS
  instance_type           = "t2.micro" 
  iam_instance_profile = "Role_SSM"
  subnet_id = var.infra-subnet_privada2_id
  vpc_security_group_ids = [var.infra-sg_id]
  key_name = var.infra-keypair_name
  associate_public_ip_address = false
  user_data = <<-EOF
          #!/bin/bash
          sudo apt update && sudo apt install curl ansible unzip -y 
          cd /tmp
          wget https://executaveis2024.s3.amazonaws.com/ansible.zip
          unzip ansible.zip
          sudo ansible-playbook wordpress.yml
          EOF

   
   tags = {
        Name = "Server_Wordpress"
    }

  
 
  depends_on = [var.infra-subnet_privada2_id]
}

 output "instance_2_ip" {
  value = aws_instance.instance_1.public_ip
 }

