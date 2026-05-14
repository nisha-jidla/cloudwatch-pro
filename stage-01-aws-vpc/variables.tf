variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "cloudwatch-pro"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "my_ip" {
  type    = string
  default = "82.34.249.89"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID for eu-west-2"
  type        = string
  default     = "ami-0012c588d293b9e2a"
}
