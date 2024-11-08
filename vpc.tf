module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_config.name
  cidr = var.vpc_config.cidr

  azs             = var.vpc_config.azs
  private_subnets = var.vpc_config.private_subnets
  public_subnets  = var.vpc_config.public_subnets

  enable_nat_gateway = var.vpc_features.enable_nat_gateway
  single_nat_gateway = var.vpc_features.single_nat_gateway
  one_nat_gateway_per_az = var.vpc_features.one_nat_gateway_per_az
  
  enable_dns_hostnames = var.vpc_features.enable_dns_hostnames
  enable_dns_support   = var.vpc_features.enable_dns_support

  tags = var.tags
}

