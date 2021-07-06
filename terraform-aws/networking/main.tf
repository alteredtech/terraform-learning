# --- networking/main.tf ---

#data resource for the availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

#creating a random number
resource "random_integer" "random" {
  min = 1
  max = 100
}

#randomizes the availability zones for how many subnet we have
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

#creates the vpc for alt = alteredtech with a random id
resource "aws_vpc" "alt_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "alt_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#creates the public subnets and uses the random availability zone
resource "aws_subnet" "alt_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.alt_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "alt_public_${count.index + 1}"
  }
}

#addes the public subnets to the public route table
resource "aws_route_table_association" "alt_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.alt_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.alt_public_route.id
}

#creates the private subnets and uses a random availability zone
resource "aws_subnet" "alt_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.alt_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "alt_private_${count.index + 1}"
  }
}

#the gateway for the public route table and private route table
# only the public route table will have direct access
resource "aws_internet_gateway" "alt_internet_gateway" {
  vpc_id = aws_vpc.alt_vpc.id

  tags = {
    Name = "alt_igw"
  }
}

#creating the public route table
resource "aws_route_table" "alt_public_route" {
  vpc_id = aws_vpc.alt_vpc.id

  tags = {
    Name = "alt_public"
  }
}

#creating the default route with allows all ips
#linking it to the public route table and gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.alt_public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.alt_internet_gateway.id
}

#creating the default route table for the private route table
resource "aws_default_route_table" "alt_private_route_table" {
  default_route_table_id = aws_vpc.alt_vpc.default_route_table_id

  tags = {
    Name = "alt_private"
  }

}

#creating security groups
resource "aws_security_group" "alt_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.alt_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "alt_rds_subnetgroup" {
  count      = var.db_subnet_group ? 1 : 0
  name       = "alt_rds_subnetgroup"
  subnet_ids = aws_subnet.alt_private_subnet.*.id
  tags = {
    Name = "alt_rds_sng"
  }
}