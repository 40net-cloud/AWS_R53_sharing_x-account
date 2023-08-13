# Define the aws region
provider "aws"  {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "${var.prefix}-r53"
  }
}

# availability_zone A

# Subnet PublicSubnet1
resource "aws_subnet" "PublicSubnet1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-PublicSubnet1"
    }
}

# Subnet PrivateSubnet1
resource "aws_subnet" "PrivateSubnet1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-PrivateSubnet1"
    }
}

# Subnet PrivateSubnet3
resource "aws_subnet" "PrivateSubnet3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-PrivateSubnet3"
    }
}

# Subnet PublicSubnet3
resource "aws_subnet" "PublicSubnet3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-PublicSubnet3"
    }
}

# availability_zone B

# Subnet PublicSubnet2
resource "aws_subnet" "PublicSubnet2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.10.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-PublicSubnet2"
    }
}

# Subnet PrivateSubnet2
resource "aws_subnet" "PrivateSubnet2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.20.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-PrivateSubnet2"
    }
}

# Subnet PrivateSubnet4
resource "aws_subnet" "PrivateSubnet4" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.30.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-PrivateSubnet4"
    }
}

# Subnet PublicSubnet4
resource "aws_subnet" "PublicSubnet4" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.40.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-PublicSubnet4"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "ig-main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}


resource "aws_eip" "nat_gateway" {
    domain = "vpc"
    }

resource "aws_nat_gateway" "natgw-main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.PublicSubnet1.id
  tags = {
    Name = "${var.prefix}-gwNAT"
  }
}

# Create a RT for Nat gateway
resource "aws_route_table" "nat-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-main.id
  }
  tags = {
    Name = "${var.prefix}-nat-routable"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.nat-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.nat-rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.PrivateSubnet4.id
  route_table_id = aws_route_table.nat-rt.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.PrivateSubnet3.id
  route_table_id = aws_route_table.nat-rt.id
}


# Create an aws route in the main routing table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig-main.id
}


output "vpc_id" {
value = "${aws_vpc.main.id}"
}
