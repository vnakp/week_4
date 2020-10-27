variable "cidr_vpc_eng" {
  description = "CIDR block for Engineering VPC"
  default     = "10.8.0.0/16"
}
variable "cidr_subnet_prom" {
  description = "CIDR block for private prometheus subnet"
  default     = "10.8.1.0/24"
}

variable "cidr_subnet_graf" {
  description = "CIDR block for public grafana subnet"
  default     = "10.8.2.0/24"
}
variable "environment_tag" {
  description = "Grafana Tag"
  default     = "Grafana"
}

variable "region" {
  description = "The region Terraform deploys instance"
  default     = "eu-west-1"
}

