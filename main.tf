# Create a VPC to launch our instances into
# This VPC will contain all our AWS resources and provide network isolation
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16" # Provides 65,536 IP addresses
  enable_dns_hostnames = true          # Enable DNS hostnames for instances
  enable_dns_support   = true          # Enable DNS resolution

  tags = {
    Name = "deham37-training-vpc"
  }
}

# Internet Gateway — required for public subnet outbound traffic
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "deham37-igw"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24" # 256 addresses within the VPC range
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true          # Instances get a public IP automatically

  tags = {
    Name = "deham37-public-subnet"
  }
}

# Route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name = "deham37-public-rt"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Second public subnet (different AZ for high availability)
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.2.0/24" # 256 addresses within the VPC range
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true          # Instances get a public IP automatically

  tags = {
    Name = "deham37-public-subnet-2"
  }
}

# Associate the second public subnet with the public route table
resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
