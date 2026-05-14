module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  availability_zones   = ["eu-west-2a", "eu-west-2b"]
}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  my_ip        = var.my_ip
}

module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.ami_id
  instance_type     = "t3.micro"
  private_subnet_id = module.vpc.private_subnet_ids[0]
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  app_sg_id         = module.security_groups.app_sg_id
  public_key_path   = "~/.ssh/cloudwatch-pro/cloudwatch-pro-key.pub"
}

module "alb" {
  source             = "./modules/alb"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  alb_sg_id          = module.security_groups.alb_sg_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  instance_id        = module.ec2.instance_id
}
