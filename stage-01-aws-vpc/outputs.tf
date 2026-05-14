output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "app_sg_id" {
  value = module.security_groups.app_sg_id
}

output "ec2_private_ip" {
  value = module.ec2.private_ip
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
