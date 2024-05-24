module "vpc" {
  source = "./modules/VPC"
  vpc_cidr = var.vpc_cidr
  subent_cidr = var.subent_cidr
}

module "sg-module" {
  source = "./modules/SG"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/EC2"
  sg_id = module.sg-module.sg_id
  subnet_id = module.vpc.subnet_ids
}

module "alb" {
  source = "./modules/ALB"
  sg_ids = module.sg-module.sg_id
  subnet_ids = module.vpc.subnet_ids
  vpc_id = module.vpc.vpc_id
  instances = module.ec2.instance_ids
}