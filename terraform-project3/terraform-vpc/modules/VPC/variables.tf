variable "vpc_cidr" {
  description = "CIDR for vpc"
  type = string
}

variable "subent_cidr" {
  description = "CIDR for subnets"
  type = list(string)
}

variable "subnet_names" {
  description = "names of the public subnets"
  type = list(string)
  default = [ "pub-sub1","pub-sub2" ]
}