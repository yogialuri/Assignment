# VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  tags {
    Name = "VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  tags {
    Name = "IGW"
  }
}

# Virtual private gateway

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.terra_vpc.id}"

  tags = {
    Name = "VPN"
  }
}

# Subnets : private
resource "aws_subnet" "subnet1" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags {
    Name = "Subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags {
    Name = "Subnet2"
  }
}


resource "aws_subnet" "subnet3" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"
  tags {
    Name = "Subnet3"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "crt1" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terra_igw.id}"
  }
  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = "${aws_internet_gateway.terra_igw.id}"
  }

  tags {
    Name = "customRouteTable1"
  }
}


resource "aws_route_table" "crt2" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terra_igw.id}"
  }
 

  tags {
    Name = "customRouteTable2"
  }
}


# Route table association

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.crt1.id}"
}


resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.subnet3.id}"
  route_table_id = "${aws_route_table.crt2.id}"
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = "172.0.0.1"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = "${aws_vpn_gateway.vpn_gateway.id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "corporate" {
  destination_cidr_block = "xxxxxxxxx"
  vpn_connection_id      = "${aws_vpn_connection.main.id}"
}