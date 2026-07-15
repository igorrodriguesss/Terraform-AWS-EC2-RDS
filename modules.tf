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
