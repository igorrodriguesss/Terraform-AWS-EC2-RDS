variable "project_name" {
  type        = string
  description = "Project name to be used to name the resources (Name tag)"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all AWS resources"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the EC2 instance"
}

variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet where the EC2 instance will be launched"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EC2 instance will be launched"
}