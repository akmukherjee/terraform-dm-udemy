# --- root/main.tf 

module "networking" {
  source           = "./networking"
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 20
  cidr_block       = local.vpc_cidr
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true

}

module "loadbalancing" {
  source              = "./loadbalancing"
  public_sg           = module.networking.public_sg
  public_subnets      = module.networking.public_subnets
  tg_port             = var.tg_port
  vpc_id              = module.networking.vpc_id
  healthy_threshold   = var.healthy_threshold
  unhealthy_thredhold = var.unhealthy_threshold
  lb_timeout          = var.lb_timeout
  lb_interval         = var.lb_interval
  listener_port = var.listener_port
  listener_protocol = var.listener_protocol
}
/* 
 module "database" {
  source = "./database"
  db_storage           = 10
  db_engine_version    = "5.7.22"
  instance_class       = "db.t2.micro"
  dbname               = var.dbname
  dbuser               = var.dbuser
  dbpassword           = var.dbpassword
  db_identifier        =  "mtc-db"
  db_skip_final_snapshot  = true
  db_subnet_group_name = module.networking.db_subnet_name[0]
  vpc_security_group_ids = module.networking.db_security_group_ids
  
}  */