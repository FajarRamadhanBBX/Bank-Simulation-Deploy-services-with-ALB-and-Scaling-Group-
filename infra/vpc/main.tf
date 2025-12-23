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

resource "aws_subnet" "public" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    
    tags = {
        Name = "public-subnet-${count.index + 1}"
    }
}

