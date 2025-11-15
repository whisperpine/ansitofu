variable "cidr_block" {
  description = "the CDIR block that will be used in the vpc"
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones to create subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnets"
  type        = list(string)
}
