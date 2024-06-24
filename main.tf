
module "infrastructure" {
  source = "./modules/infrastructure"
}



module "ec2" {
  source                   = "./modules/ec2"
  infra-subnet_privada1_id = module.infrastructure.subnet_privada1_id
  infra-subnet_privada2_id = module.infrastructure.subnet_privada2_id
  infra-sg_id              = module.infrastructure.securit_group_id
  infra-keypair_name       = module.infrastructure.keypair_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket  = "tf-state-projeto-elvenworks"
    key     = "terraform/terraform.tfstate"
    encrypt = true
    region  = "us-east-1"

  }

}





