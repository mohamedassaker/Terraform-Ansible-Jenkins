resource "aws_vpc" "vpc" {
    cidr_block           = "10.1.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.subnet_cidr_block
    availability_zone = var.availability_zone
    
    tags = {
        Name = "${var.env_prefix}-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.env_prefix}-internet-gateway"
    }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.env_prefix}-route-table"
    }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "rtb_subnet" {
    subnet_id      = aws_subnet.subnet.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg" {
    name   = "${var.env_prefix}-sg"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "ssh_key" {
    key_name   = "${var.env_prefix}-key-pair"
    public_key = file(var.ssh_key)
}

resource "aws_instance" "jenkins-server" {
    ami                         = var.ec2_ami_id
    instance_type               = var.instance_type
    key_name                    = "${aws_key_pair.ssh_key.key_name}"
    subnet_id                   = aws_subnet.subnet.id
    vpc_security_group_ids      = [aws_security_group.sg.id]
    availability_zone           = var.availability_zone
    associate_public_ip_address = true
    user_data                   = base64encode(file("../../../files/install_jenkins.sh"))

    tags = {
        Name = "${var.env_prefix}-server"
    }
}