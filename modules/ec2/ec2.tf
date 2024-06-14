module "infrastructure" {
  source = "../infrastructure"

}

resource "aws_instance" "instance_1" {
  ami                     = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04 LTS
  instance_type           = "t2.micro" 
  subnet_id = module.infrastructure.subnet_publica1_id
  vpc_security_group_ids = [module.infrastructure.sg_id]
  key_name = module.infrastructure.keypair_name
  associate_public_ip_address = true
   
   tags = {
        Name = "Ubuntu"
    }

  
  depends_on = [module.infrastructure]
}

  output "instance_1_name" {
  value = aws_instance.instance_1.tags
 }

  output "instance_1_ip" {
  value = aws_instance.instance_1.public_ip
 }


//// Ansible 
resource "aws_instance" "instance_2" {
  ami                     = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04 LTS
  instance_type           = "t2.micro" 
  subnet_id = module.infrastructure.subnet_publica1_id
  vpc_security_group_ids = [module.infrastructure.sg_id]
  key_name = module.infrastructure.keypair_name
  associate_public_ip_address = true
  user_data = <<-EOF
          #/bin/bash
          sudo apt update && sudo apt install curl ansible unzip -y 
          cd /tmp
          wget htt
          unzip ansible.zip
          sudo ansible-playbook wordpress.yml
          EOF

   
   tags = {
        Name = "Ansible"
    }

  
  depends_on = [module.infrastructure]
}

 output "instance_2_ip" {
  value = aws_instance.instance_1.public_ip
 }

 output "instance_2_name" {
  value = aws_instance.instance_2.tags
 }