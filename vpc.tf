resource "aws_vpc" "alessandro_vpc" {
  cidr_block = "10.0.0.0/28" # It's just a single EC2 instance, we do not need many addresses.
  enable_dns_hostnames = true
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

resource "aws_internet_gateway" "alessandro_gw" {
  vpc_id = aws_vpc.alessandro_vpc.id

  tags = {
    Name = "alessandro-gw"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow-http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.alessandro_vpc.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },

    # NEEDS TO BE REMOVED AFTERWARDS
    {
      description      = "HTTP"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

   egress = [
    {
      description      = "for all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  tags = {
    Name = "Allow-HTTP"
  }
}

resource "aws_route_table" "alessandro_route_table" {
    vpc_id = aws_vpc.alessandro_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.alessandro_gw.id
    }

    tags = {
        Name = "Public Subnet Route Table."
    }
}

resource "aws_route_table_association" "alessandro_route_table_association" {
    subnet_id = aws_subnet.alessandro_subnet_a.id
    route_table_id = aws_route_table.alessandro_route_table.id
}