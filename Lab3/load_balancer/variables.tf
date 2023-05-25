variable "listen_port" {
    type = number
    default = 80
}

variable "listen_protocol" {
    type = string
    default = "HTTP"
}

variable "my_subnets_ids" {
    type = list(string)
}


variable "my_sg" {
    type = string
}

variable "my_vpc_id" {
    type = string
}

variable "Pub_instances" {
    type = list
}

variable "Private_instances" {
    type = list
}