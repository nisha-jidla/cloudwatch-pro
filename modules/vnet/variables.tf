variable "project_name" { type = string }
variable "environment"  { type = string }
variable "location"     { type = string }

variable "vnet_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.1.10.0/24"
}
