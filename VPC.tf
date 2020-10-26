resource "aws_vpc" "itsvpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "pub_sn" {
  vpc_id     = "${aws_vpc.itsvpc.id}"
  cidr_block = "172.31.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pri_sn" {
  vpc_id     = "${aws_vpc.itsvpc.id}"
  cidr_block = "172.31.16.0/24"
}

resource "aws_internet_gateway" "int_gw" {
  vpc_id = "${aws_vpc.itsvpc.id}"

  tags = {
    Name = "Internet GW"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.itsvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.int_gw.id}"
  }

  tags = {
    Name = "Route Table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.pub_sn.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}
