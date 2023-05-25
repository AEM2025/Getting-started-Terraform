variable "my_vpc_id" {
  type        = string
}
variable "key_name" {
  type        = string
  default     = "key"
}



variable "sg-ports" {
  type    = list(string)
  default = ["80" , "22" , "0"]
}
variable "RT_cidr_block" {
  type        = string
  default     = "0.0.0.0/0" 
}

variable "my_subnets_ids" {
  type        = list(string)
}

variable "ec2_type" {
  type        = string
  default     = "t2.micro"
}


variable "ec2_ami_filter" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "ec2_ami_owner" {
  type        = string
  default     = "099720109477"
}

variable "private_lb_dns" {
  type        = string
  description = "DNS of private load balancer"
}
