#VPC

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr

  tags = {
    name = "sample-vpc"
  }
}


#subents

resource "aws_subnet" "pub-sub" {
  count = length(var.subent_cidr)
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subent_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    name = var.subnet_names[count.index]
  }
}


#internet gateway

resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    name = "my-igw"
  }
}

#route table

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0" #public
    gateway_id = aws_internet_gateway.sample-igw.id
  }

  tags = {
    Name = "sample-rt"
  }
}


#route table association

resource "aws_route_table_association" "rta" {
  count = length(var.subnet_names)
  subnet_id = aws_subnet.pub-sub[count.index].id
  route_table_id = aws_route_table.rt.id

}