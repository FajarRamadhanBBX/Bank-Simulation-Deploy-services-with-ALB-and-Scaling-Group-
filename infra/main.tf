module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  eip_allocation_ids = module.vpc.eip_allocation_ids
  alb_sg_id = module.security_group.alb_sg_id
}

module "ecr" {
  source = "./modules/ecr"
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  db_sg_id = module.security_group.db_sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name = var.db_name
  db_username = var.db_user
  db_password = var.db_password
}

module "security_group" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "compute" {
  source = "./modules/compute"
  ec2_instance_profile_name = module.iam.ec2_instance_profile_name
  ecr_url = module.ecr.ecr_url
  db_host = module.rds.db_address
  db_user = var.db_user
  db_password = var.db_password
  db_name = var.db_name

  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id = module.security_group.app_sg_id
  lb_target_group_arn = module.alb.target_group_arn
}