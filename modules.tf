module "network" {
  source       = "./modules/network"
  cidr_block   = var.cidr_block
  project_name = var.project_name
  tags = merge(
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

module "ec2_instance" {
  source       = "./modules/ec2_instance"
  ami_id       = var.ami_id
  instance_type = var.instance_type
  project_name = var.project_name
  public_subnet_id = module.network.public_subnet
  vpc_id = module.network.vpc_id
  tags = merge(
    {
      Name = "${var.project_name}-ec2-instance"
    }
  )
}

module "database" {
  source              = "./modules/database"
  allocated_storage   = var.allocated_storage
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  parameter_group_name = var.parameter_group_name 
  private_subnets     = module.network.private_subnets
  tags                = var.tags
  project_name        = var.project_name
  publicly_accessible = var.publicly_accessible
  vpc_id = module.network.vpc_id
}