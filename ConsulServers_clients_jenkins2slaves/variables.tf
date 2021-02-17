terraform {
  required_version = ">= 0.12.0"
}

variable "region" {
  description = "AWS region for VMs"
  default     = "us-east-1"
}
variable "vpc_id" {
  description = "AWS VPC id"
  default     = "main"
}

variable "public_subnet_list" {
  type    = list(string)
  default = ["192.168.20.0/24", "192.168.40.0/24", "192.168.60.0/24"]
}

variable "private_subnet_list" {
  type    = list(string)
  default = ["192.168.10.0/24", "192.168.30.0/24"]
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22]
}


variable "ami" {
  description = "ami (ubuntu 18) to use - based on region"
  default = {
    "us-east-1" = "ami-00ddb0e5626798373"
  }
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.8.5"
}


variable "az_list" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

