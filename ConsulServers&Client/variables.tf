terraform {
  required_version = ">= 0.12.0"
}

variable "region" {
  description = "AWS region for VMs"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "AWS VPC id"
  default     = "vpc-07"
}

variable "subnet_id" {
  description = "Consol Subnet id"
  default     = "subnet-005"
}
variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22]
}


variable "ami" {
  description = "ami (ubuntu 18) to use - based on region"
  default = {
    "us-east-1" = "ami-00ddb0e562679837"
    "us-east-2" = "ami-0dd9f0e7df0f0a13"
  }
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.8.5"
}
