resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "my-vpc"
    }
}

# internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
        Name = "my-igw-1"
    }

}

