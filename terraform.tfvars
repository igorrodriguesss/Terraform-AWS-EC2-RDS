cidr_block   = "10.0.0.0/16"
project_name = "terraform_tbc"
region       = "us-east-1"
tags = {
  environment = "dev"
  Owner       = "Igor Rodrigues"
}  

ami_id        = "ami-0b6d9d3d33ba97d99"
instance_type = "t3.micro"