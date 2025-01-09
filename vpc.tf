#create VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Terra VPC"
  }
}

#create internet gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id
}

#create a subnets: public
resource "aws_subnet" "public" {
  count = length(var.subnets_cidr)
  vpc_id = aws_vpc.terra_vpc.id
  cidr_block = element(var.subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet_new-${count.index + 1}"
  }
}

#Route table attach internet gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags = {
    Name = "Public_route_table"
  }
}

#Route table association with public subnet
resource "aws_route_table_association" "a" {
  count = length(var.subnets_cidr)
  route_table_id = aws_route_table.public_rt.id
  subnet_id = element(aws_subnet.public.*.id, count.index )
}