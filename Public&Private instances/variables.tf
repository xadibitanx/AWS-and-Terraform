terraform {
  required_version = ">= 0.12.0"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"

}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22]
}

variable "az_list" {
 type    = list(string)
 default = ["us-east-1a", "us-east-1b"]
}

variable "web_subnet_list" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "db_subnet_list_B" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}


