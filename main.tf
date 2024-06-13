
module "infrastructure" {
  source = "./modules/infrastructure"

}

/*module "ec2" {
  source = "./modules/ec2"

}
*/
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

