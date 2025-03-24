resource "aws_vpc" "steve_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "steve-vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.steve_vpc.id
  cidr_block              = var.public_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "steve-public-subnet"
  }
}


resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.steve_vpc.id
  cidr_block              = var.public_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "steve-public-subnet"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.steve_vpc.id
  cidr_block              = var.private_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "steve-private-subnet"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.steve_vpc.id
  cidr_block              = var.private_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "steve-private-subnet"
  }
}



# This section creates an INTERNET GATEWAY and Route Table association for PUBLIC Subnetes to access the internet

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.steve_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.steve_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "steve-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}


#  THIS EXRA PART IS NECESSARY ONL IF WE ARE HSOTING INSIDE A PRIVATE SUBNET

resource "aws_eip" "nat_eip" {
  vpc = true
}


resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "steve-nat-gw1"
  }
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = {
    Name = "steve-nat-gw2"
  }
}

resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.steve_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw1.id
  }

  tags = {
    Name = "steve-private-rt1"
  }
}

resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.steve_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw2.id
  }

  tags = {
    Name = "steve-private-rt2"
  }
}

resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt1.id
}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt2.id
}

