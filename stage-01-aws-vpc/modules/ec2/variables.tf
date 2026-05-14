variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "private_subnet_id" {
  description = "Private subnet ID to launch instance in"
  type        = string
}

variable "app_sg_id" {
  description = "App security group ID"
  type        = string
}

variable "public_key_path" {
  description = "Path to public SSH key"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID to launch instance in"
  type        = string
}