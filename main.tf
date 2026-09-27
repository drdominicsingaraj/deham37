# Create a VPC to launch our instances into
# This VPC will contain all our AWS resources and provide network isolation
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16" # Provides 65,536 IP addresses
  enable_dns_hostnames = true          # Enable DNS hostnames for instances
  enable_dns_support   = true          # Enable DNS resolution

  tags = {
    Name = "deham37-vpc"
  }
}