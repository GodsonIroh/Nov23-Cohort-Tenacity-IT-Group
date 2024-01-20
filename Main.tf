# Provisioning the required Infrastructure networking of Tenacity IT Group

resource "aws_vpc" "Nov-Cohort-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Nov-Cohort-VPC"
  }
}

resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.Nov-Cohort-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod-pub-sub1"
  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.Nov-Cohort-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Prod-pub-sub2"
  }
}

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.Nov-Cohort-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Prod-priv-sub1"
  }
}

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.Nov-Cohort-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Prod-priv-sub2"
  }
}

resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.Nov-Cohort-VPC.id

  tags = {
    Name = "Prod-pub-route-table"
  }
  }

  resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.Nov-Cohort-VPC.id

  tags = {
    Name = "Prod-priv-route-table"
  }
  }

  resource "aws_route_table_association" "Public-RTA1" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "Public-RTA2" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "Private-RTA1" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_route_table_association" "Private-RTA2" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Nov-Cohort-VPC.id

  tags = {
    Name = "Prod-igw"
  }
}

resource "aws_internet_gateway_attachment" "Prod-igw-association" {
  internet_gateway_id = aws_internet_gateway.Prod-igw.id
  vpc_id              = aws_vpc.Nov-Cohort-VPC.id
}

resource "aws_route" "Public-route" {
  route_table_id            = aws_route_table.Prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Prod-igw.id
}

resource "aws_eip" "Nat-eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "Prod-Nat-gateway" {
  allocation_id = aws_eip.Nat-eip.id
  subnet_id     = aws_subnet.Prod-priv-sub1.id

  tags = {
    Name = "Prod-Nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Prod-igw]
}

resource "aws_route" "NAT-route" {
  route_table_id            = aws_route_table.Prod-priv-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.Prod-Nat-gateway.id
}  
