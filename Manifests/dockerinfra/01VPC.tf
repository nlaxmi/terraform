# VPC CIDR-Block
resource "aws_vpc" "vpc" {
	cidr_block = "10.1.0.0/16"
	tags = {
		Name = "docker"
	}
}

# Internet Gateway
resource "aws_internet_gateway" "igw01" {
	vpc_id = "${aws_vpc.vpc.id}"
	tags = {
		Name = "docker-igw01"
	}
}

# Route Table - PUBLIC
resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.igw01.id}"
	}
	tags = {
		Name = "docker-public"
	}
}

# Route Table - PRIVATE
resource "aws_default_route_table" "private" {
	default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
	tags = {
		Name = "docker-private"
	}
}

# Subnet - PUBLIC
resource "aws_subnet" "public" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.1.0/24"
	map_public_ip_on_launch = true
	availability_zone = "us-east-1a"
	tags = {
		Name = "docker-public"
	}
}

# Subnet - PRIVATE01
resource "aws_subnet" "private1" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.10.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-east-1b"
	tags = {
		Name = "docker-private1"
	}
}

# Subnet - PRIVATE02
resource "aws_subnet" "private2" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.20.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-east-1c"
	tags = {
		Name = "docker-private2"
	}
}

# Subnet association with Route Table - PUBLIC
resource "aws_route_table_association" "public_assoc" {
	subnet_id = "${aws_subnet.public.id}"
	route_table_id = "${aws_route_table.public.id}"
}

# Subnet association with Route Table - PRIVATE1
resource "aws_route_table_association" "private1-assoc" {
	subnet_id = "${aws_subnet.private1.id}"
	route_table_id = "${aws_route_table.public.id}"
}

# Subnet association with Route Table - PRIVATE2
resource "aws_route_table_association" "private2-assoc" {
	subnet_id = "${aws_subnet.private2.id}"
	route_table_id = "${aws_route_table.public.id}"
}

# Security Group - JUMPHOST
resource "aws_security_group" "jumphost" {
	name = "docker-sg_jumphost"
	description = "Used for Jump host access"
	vpc_id = "${aws_vpc.vpc.id}"
	
	# SSH-INGRESS
	ingress {
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	tags = {
		Name = "docker-sg_jumphost"
	}
}

# Data resource to whitelist local ip
data "external" "localip" {
	program = ["sh", "${path.module}/myip.sh"]
}

# Security Group - PUBLIC
resource "aws_security_group" "public" {
	name = "docker-sg_public"
	description = "Used for Public and Private instances for load balancer access"
	vpc_id = "${aws_vpc.vpc.id}"

	# SSH-INGRESS
	ingress {
		description = "Allow SSH"
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["${data.external.localip.result["myip"]}","${aws_vpc.vpc.cidr_block}"]
	}
	
	# HTTP-INGRESS
	ingress {
		description = "Allow HTTP"
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	# DOCKER-INGRESS
	ingress {
		description = "Allow communication between docker instances"
		from_port	= 2377
		to_port		= 2377
		protocol	= "tcp"
		cidr_blocks	= ["${aws_vpc.vpc.cidr_block}"]
	}

	# EGRESS
	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	tags = {
		Name = "docker-sg_public"
	}
}

# Security Group - PRIVATE
resource "aws_security_group" "private" {
	name = "docker-sg_private"
	description = "Used for private instances"
	vpc_id = "${aws_vpc.vpc.id}"
	
	# Access from other security groups
	ingress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["10.1.0.0/16"]
	}
	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	tags = {
		Name = "docker-sg_private"
	}
}