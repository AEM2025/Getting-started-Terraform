variable "vpc_region" {
  type        = string
  # default     = vpc_region
}

variable "shared_config_file" {
  type        = list(string)
  # default     = ["/home/aem/.aws/config"]
}

variable "shared_credentials_file" {
  type        = list(string)
  # default     = ["/home/aem/.aws/credentials"]
}

variable "vpc_cidr_block" {
  type        = string
  # default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type        = list(string)
  # default     = ["10.0.0.0/24","10.0.1.0/24"]
}

variable "az_names" {
  type        = list(string)
  # default     = ["us-east-1a" , "us-east-1b"]
}

variable "RT_cidr_block" {
  type        = string
  # default     = "0.0.0.0/0" 
}

variable "ec2_type" {
  type        = string
  # default     = "t2.micro"
}

variable "ec2_ami" {
  type        = string
  # default     = "ami-007855ac798b5175e"
}

variable "public_ip" {
  type        = list(bool)
}

variable "sg-ports" {
  type        = list(string)
}
