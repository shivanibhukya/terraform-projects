variable "sg_ids" {
  description = "ids of security groups"
  type = string
}

variable "subnet_ids" {
  description = "ids of the subnets"
  type = list(string)
}


variable "vpc_id" {
  description = "id of vpc"
  type = string
}


variable "instances" {
  description = "instances"
  type = list(string)
}