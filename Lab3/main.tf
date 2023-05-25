module "vpc" {
    source = "./vpc"
}

module "subnets" {
    source = "./subnets"
    my_vpc_id = module.vpc.vpc_id
    my_igw_id = module.vpc.igw_id
}

module "ec2_instances" {
    source = "./ec2"
    my_vpc_id = module.vpc.vpc_id
    my_subnets_ids = module.subnets.my_subnets
    private_lb_dns = module.my_lb.private_lb_dns
}
module "my_lb" {
    source = "./load_balancer"
    my_subnets_ids = module.subnets.my_subnets
    my_sg = module.ec2_instances.my_sg
    my_vpc_id = module.vpc.vpc_id
    Pub_instances = module.ec2_instances.Pub_instances_ids
    Private_instances = module.ec2_instances.Private_instances_ids
}
