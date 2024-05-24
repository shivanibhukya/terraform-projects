variable "vpc_cidr" {
  description = "CIDR for vpc"
  type = string
}
variable "subent_cidr" {
  description = "CIDR for subnets"
  type = list(string)
}