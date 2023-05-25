vpc_region = "us-east-1"
shared_config_file = ["/home/aem/.aws/config"]
shared_credentials_file = ["/home/aem/.aws/credentials"]
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = ["10.0.0.0/24","10.0.1.0/24"]

az_names = ["us-east-1a" , "us-east-1b"]
RT_cidr_block = "0.0.0.0/0" 
ec2_type = "t2.micro"
ec2_ami = "ami-007855ac798b5175e"
public_ip = [true, false]
sg-ports = ["80" , "22" , "0"]
