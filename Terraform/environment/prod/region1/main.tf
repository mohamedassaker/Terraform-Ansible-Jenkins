provider "aws" {
  region = var.region
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

data "aws_ami" "amazon_ubuntu_image" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240423"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

}

module "jenkins_environment" {
    source = "../../../modules"
    
    region = var.region
    vpc_cidr_block = var.vpc_cidr_block
    subnet_cidr_block = var.subnet_cidr_block
    env_prefix = var.env_prefix
    instance_type = var.instance_type
    availability_zone = var.availability_zone
    ssh_key = var.ssh_key
    ec2_ami_id = data.aws_ami.amazon_ubuntu_image.id
  
}