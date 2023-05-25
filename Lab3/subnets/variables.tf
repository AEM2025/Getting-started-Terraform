variable "subnet_cidr_block" {
    type        = list(string)
    default     = ["10.0.0.0/24","10.0.2.0/24", "10.0.1.0/24","10.0.3.0/24"]
}

variable "az_names" {
    type        = list(string)
    default     = ["us-east-1a" , "us-east-1b", "us-east-1c" , "us-east-1d"]
}

variable "public_ip" {
    type        = list(bool)
    default = [true, false]
}




variable "RT_cidr_block" {
    type        = string
    default     = "0.0.0.0/0" 
}

variable "my_vpc_id" {
  type        = string
}

variable "my_igw_id" {
  type        = string
}

