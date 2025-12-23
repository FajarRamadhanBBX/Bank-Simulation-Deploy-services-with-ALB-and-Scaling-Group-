# vpc
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "main-vpc"
    }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-igw"
    }
}

# public subnets
resource "aws_subnet" "public" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "public-subnet-${count.index + 1}"
    }
}

# private subnets
resource "aws_subnet" "private" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = false
    tags = {
        Name = "private-subnet-${count.index + 1}"
    }
}

# elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
    count = length(var.availability_zones)
    domain = "vpc"
    tags = {
        Name = "nat-eip-${count.index + 1}"
    }
}

# NAT Gateways
resource "aws_nat_gateway" "nat" {
    count = length(var.availability_zones)
    allocation_id = aws_eip.nat_eip[count.index].id
    subnet_id = aws_subnet.public[count.index].id
    tags = {
        Name = "nat-gateway-${count.index + 1}"
    }
    depends_on = [ aws_internet_gateway.igw ]
}

# public route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main

    route {
        cidr_block = var.ip_internet
        gateway_id = aws_internet_gateway.igw.id
    }
}

# private route table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main

    route {
        cidr_block = var.ip_internet
        gateway_id = aws_nat_gateway.nat.id
    }
}

# public route table associations
resource "aws_route_table_association" "public" {
    count = length(var.public_subnets_cidr)
    route_table_id = aws_route_table.public.id
    subnet_id = aws.subnet.public[count.index].id
}

# private route table associations
resource "aws_route_table_association" "private" {
    count = length(var.private_subnets_cidr)
    route_table_id = aws_route_table.private.id
    subnet_id = aws.subnet.private[count.index].id
}