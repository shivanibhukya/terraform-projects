variable "sg_id" {
  description = "id of security group"
  type = string
}

variable "subnet_id" {
  description = "ids of subnets"
  type = list(string)
}

variable "instance_names" {
  description = "names of the instances"
  type = list(string)
  default = [ "webserver1","webserver2" ]
}