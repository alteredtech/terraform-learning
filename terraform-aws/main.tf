# --- root/main.tf

#module for creating our network vpc cidr block, how many public and private subnets,
#the max subnets we should create, and for loop through creating the subnets with the cidr function
module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true
}

module "database" {
  source                 = "./database"
  db_storage             = 10 #gibibytes
  db_engine_version      = "5.7.22"
  db_instance_class      = "db.t2.micro"
  db_identifier          = "alt-db"
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  skip_final_snapshot    = true
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.vpc_security_group_ids
}

module "loadbalancer" {
  source                 = "./loadbalancer"
  public_sg              = module.networking.public_sg
  public_subnets         = module.networking.public_subnets
  tg_port                = 8000
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "compute" {
  source              = "./compute"
  instance_count      = 1
  instance_type       = "t3.micro"
  vol_size            = "10"
  public_sg           = module.networking.public_sg
  public_subnets      = module.networking.public_subnets
  key_name            = "altkey"
  public_key_path     = "/home/terrauser/.ssh/key_alt_terra.pub"
  private_key_path    = "/home/terrauser/.ssh/key_alt_terra"
  user_data_path      = "${path.root}/userdata.tpl"
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  db_endpoint         = module.database.db_endpoint
  lb_target_group_arn = module.loadbalancer.lb_target_group_arn
  tg_port             = 8000
}