variable "region" {
    description = "The AWS region to deploy to"
    type        = string
    default     = "eu-west-2"
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
}

variable "subnet_cidr_block" {
    description = "The CIDR block for the subnet"
    type        = string
}

variable "env_prefix" {
    description = "The prefix to use for all resources"
    type        = string
}

variable "instance_type" {
    description = "The instance type to use for the server"
    type        = string
}

variable "availability_zone" {
    description = "The availability zone to deploy to"
    type        = string
}

variable "ssh_key" {
    description = "The path to the SSH public key to use for the server"
    type        = string
}

variable "ec2_ami_id" {
    description = "The name of the key pair to create"
    type        = string
}