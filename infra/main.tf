module "vpc" {
  source = "./modules/vpc"
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

module "ec2" {
  source              = "./modules/ec2"
  private_subnet_ids  = module.vpc.private_subnet_ids
  app_sg_id           = module.security_group.app_sg_id
  lb_target_group_arn = module.alb.target_group_arn
}