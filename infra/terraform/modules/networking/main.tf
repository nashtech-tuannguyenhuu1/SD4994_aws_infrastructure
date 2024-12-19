variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_public_subnet_for_eks" {}
variable "ap_availability_zone" {}
variable "ap_availability_zone_eks" {}

output "dev_proj_msa_vpc_id" {
  value = aws_vpc.dev_proj_msa_vpc_ap_central_1.id
}

output "dev_proj_msa_public_subnets" {
  value = aws_subnet.dev_proj_msa_public_subnets.*.id
}

output "dev_proj_msa_private_subnets_eks" {
  value = aws_subnet.dev_proj_msa_private_subnets_eks.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.dev_proj_msa_public_subnets.*.cidr_block
}

output "public_subnet_cidr_block_eks" {
  value = aws_subnet.dev_proj_msa_private_subnets_eks.*.cidr_block
}

# Setup VPC
resource "aws_vpc" "dev_proj_msa_vpc_ap_central_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Setup public subnet
resource "aws_subnet" "dev_proj_msa_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.dev_proj_msa_vpc_ap_central_1.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)

  tags = {
    Name = "dev-proj-public-subnet-1a"
  }
}

# Setup private subnet for eks
resource "aws_subnet" "dev_proj_msa_private_subnets_eks" {
  count             = length(var.cidr_public_subnet_for_eks)
  vpc_id            = aws_vpc.dev_proj_msa_vpc_ap_central_1.id
  cidr_block        = element(var.cidr_public_subnet_for_eks, count.index)
  availability_zone = element(var.ap_availability_zone_eks, count.index)

 tags = {
    Name = "dev-proj-private-subnet-${element(var.ap_availability_zone_eks, count.index)}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "dev_proj_msa_public_internet_gateway" {
  vpc_id = aws_vpc.dev_proj_msa_vpc_ap_central_1.id
  tags = {
    Name = "dev-proj-msa-igw"
  }
}

# Public Route Table
resource "aws_route_table" "dev_proj_msa_public_route_table" {
  vpc_id = aws_vpc.dev_proj_msa_vpc_ap_central_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_proj_msa_public_internet_gateway.id
  }
  tags = {
    Name = "dev-proj-msa-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "dev_proj_msa_public_rt_subnet_association" {
  count          = length(aws_subnet.dev_proj_msa_public_subnets)
  subnet_id      = aws_subnet.dev_proj_msa_public_subnets[count.index].id
  route_table_id = aws_route_table.dev_proj_msa_public_route_table.id
}

resource "aws_nat_gateway" "dev_proj_msa_nat_gateways" {
  count = length(aws_subnet.dev_proj_msa_public_subnets)

  allocation_id = aws_eip.dev_proj_msa_eips[count.index].id
  subnet_id     = aws_subnet.dev_proj_msa_public_subnets[count.index].id

  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

resource "aws_eip" "dev_proj_msa_eips" {
  count = length(aws_subnet.dev_proj_msa_public_subnets)

  tags = {
    Name = "eip-${count.index}"
  }
}

# Private Route Table
resource "aws_route_table" "dev_proj_msa_route_tables_eks" {
  count = length(aws_subnet.dev_proj_msa_private_subnets_eks)

  vpc_id = aws_vpc.dev_proj_msa_vpc_ap_central_1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_proj_msa_nat_gateways[0].id
  }

  tags = {
    Name = "dev-proj-private-rt-${aws_subnet.dev_proj_msa_private_subnets_eks[count.index].id}"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "dev_proj_msa_private_rt_subnet_association" {
  count = length(aws_subnet.dev_proj_msa_private_subnets_eks)

  subnet_id      = aws_subnet.dev_proj_msa_private_subnets_eks[count.index].id
  route_table_id = aws_route_table.dev_proj_msa_route_tables_eks[count.index].id
}