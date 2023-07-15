#######################################
############### V P C #################

# Getting the self Public IP 
data "external" "my_ip" {
  program = ["bash", "VPC/get_ip.sh"]
}

locals {
  my_public_ip = data.external.my_ip.result.my_public_ip
}


# VPC
resource "aws_vpc" "zurich_vpc" {
    cidr_block = var.default_vpc_cidr
    tags = {
        Name = "zurichVPC"
    }
}

# PUBLIC SUBNET
resource "aws_subnet" "zurich_subnet" {

    vpc_id = aws_vpc.zurich_vpc.id

    cidr_block = var.default_subnet_cidr

    tags = {
      Name = "zurich_subnet"
    }
}

#### SECURITY GROUPS ####
resource "aws_security_group" "zurich_sg" {
    vpc_id = aws_vpc.zurich_vpc.id
    description = "Security group for EC2 instances"

    ingress {
        description = "Allowing port HTTPS Connection from public internet"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allowing port 1337 from a limited range"
        from_port = 1337
        to_port = 1337
        protocol = "tcp"
        cidr_blocks = [var.default_vpc_cidr]
    }

    ingress {
        description = "Allowing port 3035 from a limited range (TCP)"
        from_port = 3035
        to_port = 3035
        protocol = "tcp"
        cidr_blocks = [var.default_vpc_cidr]
    }

    ingress {
        description = "Allowing port 3035 from a limited range (UDP)"
        from_port = 3035
        to_port = 3035
        protocol = "udp"
        cidr_blocks = [var.default_vpc_cidr]
    }

    ingress {
        description = "Allowing SSH Connection from infrastructure provisioner IP"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [local.my_public_ip]
    }

    egress {
        description = "Allowing all outbound traffic to any destination"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "SecuritGroupForEc2Instances"
    }
}


# INTERNET GATEWAY
resource "aws_internet_gateway" "zurich_vpc_gateway" {
    vpc_id = aws_vpc.zurich_vpc.id

    tags = {
        Name = "zurichIGW"
    }
}


# ROUTE TABLE
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.zurich_vpc.id

    tags = {
        Name = "PublicRouteTable"
    }
}


# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "subnet_route_table_association" {
    subnet_id = aws_subnet.zurich_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}


# ROUTE
resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zurich_vpc_gateway.id
}
