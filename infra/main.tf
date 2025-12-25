module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  db_sg_id = module.security_group.db_sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username = var.db_username
  db_password = var.db_password
}

module "security_group" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  alb_sg_id          = module.security_group.alb_sg_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  eip_allocation_ids = module.vpc.eip_allocation_ids
}

module "compute" {
  source              = "./modules/compute"
  private_subnet_ids  = module.vpc.private_subnet_ids
  app_sg_id           = module.security_group.app_sg_id
  lb_target_group_arn = module.alb.target_group_arn
}