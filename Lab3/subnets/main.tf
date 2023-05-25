# Subnet --> public 10.0.0.0/24
resource "aws_subnet" "subnet" {
    count = length(var.subnet_cidr_block)
    vpc_id = var.my_vpc_id # --------------------------------------- input here
    cidr_block = var.subnet_cidr_block[count.index]
    availability_zone = var.az_names[count.index]
    map_public_ip_on_launch = count.index <= 1 ? var.public_ip[0] : var.public_ip[1]
    tags = {
        Name = count.index <= 1 ? "Public Subnet - ${count.index + 1}" : "Private Subnet - ${count.index + 1}"
    }
}


# elastic IP
resource "aws_eip" "nateIP" {
    vpc = true
}

resource "aws_nat_gateway" "NATgw" {
    allocation_id = aws_eip.nateIP.id
    subnet_id = aws_subnet.subnet[0].id
}


# route table , 0.0.0.0/0 
resource "aws_route_table" "publicRT" {
    vpc_id = var.my_vpc_id # -----------------------------input here
    route {
        cidr_block = var.RT_cidr_block
        gateway_id = var.my_igw_id # --------------------------------- input here
    }
    tags = {
        Name="my-public-route-table"
    }
}


# route table , 0.0.0.0/0
resource "aws_route_table" "privateRT" {
    vpc_id = var.my_vpc_id # -----------------------------input here
    route {
        cidr_block = var.RT_cidr_block
        gateway_id = aws_nat_gateway.NATgw.id
    }
    tags = {
        Name="my-private-route-table"
    }
}



# Route table associations for both Public Subnet
resource "aws_route_table_association" "public" {
    count = 2
    subnet_id      = aws_subnet.subnet[count.index].id
    route_table_id = aws_route_table.publicRT.id
}



# Route table associations for both private Subnet
resource "aws_route_table_association" "private" {
    count = 2
    subnet_id      = aws_subnet.subnet[count.index + 2].id
    route_table_id = aws_route_table.privateRT.id
}
