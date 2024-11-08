# Configuracion del provider

provider "aws" {
  region = var.aws_region
}

# Configuración del backend en S3 con DynamoDB para state locking
terraform {
  backend "s3" {
    bucket         = "labfinal-tfstate-daniel"  
    key            = "terraform.tfstate"        
    region         = "us-east-1"               
    encrypt        = true
    dynamodb_table = "labfinal-lock-daniel"     
  }
}

data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = module.autoscaling.autoscaling_group_name
  }

  depends_on = [module.autoscaling]
}