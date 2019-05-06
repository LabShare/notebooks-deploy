data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags {
    Name = "jupyter"
  }
}

resource "aws_subnet" "public" {
  count = "${length(data.aws_availability_zones.available.names)}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index + 1}.0/24"
  vpc_id            = "${aws_vpc.main.id}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "jupyter"
  }
}
resource "aws_subnet" "private" {
  count = "${length(data.aws_availability_zones.available.names)}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index + 4}.0/24"
  vpc_id            = "${aws_vpc.main.id}"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "jupyter"
  }
}

resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "omero"
  }
}

resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }
  tags {
    Name = "jupyter"
  }
}

resource "aws_route_table_association" "main-public" {
  count = "${length(data.aws_availability_zones.available.names)}"

  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.main-public.id}"
}