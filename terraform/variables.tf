variable "cidr_block" {
  type        = string
  description = "Networking CIDR block to be used for the VPC"
}

variable "project_name" {
  type        = string
  description = "Project name to be used to name the resources (Name tag)"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all AWS resources"
}

variable "region" {
  type        = string
  description = "AWS region to create the resources"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the EC2 instance"
}

variable "allocated_storage" {
  type        = number
  description = "The amount of storage (in GB) to allocate for the EC2 instance"
}

variable "engine" {
  type        = string
  description = "The database engine to use for the EC2 instance"
}

variable "engine_version" {
  type        = string
  description = "The version of the database engine to use for the EC2 instance"
}

variable "instance_class" {
  type        = string
  description = "The instance class to use for the EC2 instance"
}

variable "db_name" {
  type        = string
  description = "The name of the database to create on the EC2 instance"
}

variable "username" {
  type        = string
  description = "The username for the database on the EC2 instance"
}

variable "password" {
  type        = string
  description = "The password for the database on the EC2 instance"
}

variable "parameter_group_name" {
  type        = string
  description = "The name of the parameter group to associate with the EC2 instance"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the EC2 instance should be publicly accessible"
}