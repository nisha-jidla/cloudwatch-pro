module "vnet" {
  source = "./modules/vnet"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  vnet_cidr           = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.10.0/24"
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.vnet.resource_group_name
  private_subnet_id   = module.vnet.private_subnet_id
  public_subnet_id    = module.vnet.public_subnet_id
  my_ip               = "82.34.249.89"
}

module "vm" {
  source = "./modules/vm"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.vnet.resource_group_name
  subnet_id           = module.vnet.public_subnet_id
  public_key_path     = "~/.ssh/cloudwatch-pro/cloudwatch-pro-key.pub"
}
