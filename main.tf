terraform {
 required_providers {
   aws ={
source = "hashicorp/aws"   
 version = "~> 6.0"
 }
 }
}

provider "aws" {
  region = "us-east-1"
}

#create a VPC

resource "aws_vpc" "terraform_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "terraform_vpc"

    }
}

#create a two subnets
resource "aws_subnet" "my_subnet_1" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "public_subnet"  }
        
}   

resource "aws_subnet" "my_subnet_2" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "10.0.2.0/24"

    tags = {
        Name = "private_subnet"  }
        
}   

#create a route table and connecting it to the internet gateway

resource "aws_route_table" "sameer_route" {
    vpc_id = aws_vpc.terraform_vpc.id
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    
    tags = {
        Name = "sameer_route"
    }
}

resource "aws_route_table_association" "my_route" {
    route_table_id = aws_route_table.sameer_route.id
    subnet_id = aws_subnet.my_subnet_1.id
}

resource "aws_route_table_association" "my_route_2" {
    route_table_id = aws_route_table.sameer_route.id
    subnet_id = aws_subnet.my_subnet_2.id
}


#create a internet gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.terraform_vpc.id
  
    tags = {
        Name = "my_igw"
    }
}

resource "aws_security_group" "my_sameer_group"{
    name = "my_sameer_group"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = aws_vpc.terraform_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "my_instance" {
    ami = "ami-0c02fb55956c7d316"
    instance_type = "t3.micro"
    key_name = "myserver"
    tags = {
        Name = "my_instance_1"
    }
}

