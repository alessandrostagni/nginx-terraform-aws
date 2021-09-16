resource "aws_vpc" "alessandro_vpc" {
  cidr_block = "10.0.0.0/28" # It's just a single EC2 instance, we do not need many addresses.

  tags = {
    Name = "alessandro-vpc"
  }
}

resource "aws_subnet" "alessandro_subnet_a" {
  vpc_id            = aws_vpc.alessandro_vpc.id
  cidr_block        = "10.0.0.0/28" # It's just a single EC2 instance, we do not need many addresses.
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "alessandro-subnet-a"
  }
}

resource "aws_network_interface" "alessandro_network_interface" {
  subnet_id   = aws_subnet.alessandro_subnet_a.id # We need a network interface in order to expose the subnet (and the instance) to the internet

  tags = {
    Name = "alessandro-network-interface"
  }
}