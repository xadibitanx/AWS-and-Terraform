terraform {
  required_version = ">= 0.12.0"
}

variable "ssh_key_name" {
  type = string
  default     = "MasterKeyStone"
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
  default = ["192.168.20.0/24", "192.168.40.0/24"]
}

variable "private_subnet_list" {
  type    = list(string)
  default = ["192.168.10.0/24", "192.168.30.0/24"]
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
 default = ["us-east-1a", "us-east-1b"]
}

#################################################################3

variable "kubernetes_version" {
  default = 1.18
  description = "kubernetes version"
}

variable "aws_region" {
  default = "us-east-1"
  description = "aws region"
}

locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
}
