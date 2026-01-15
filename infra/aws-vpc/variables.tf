variable "cidr_block" {
  description = "the CDIR block that will be used in the vpc"
  type        = string
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "must be a valid IPv4 CIDR block"
  }
}

variable "availability_zones" {
  description = "a list of availability zones to create subnets"
  type        = list(string)
  validation {
    condition = alltrue([
      for s in var.availability_zones :
      can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", s))
    ])
    error_message = "AZ must be in format like 'us-east-1a', 'ap-southeast-1b', etc."
  }
}

variable "public_subnets" {
  description = "a list of public subnets"
  type        = list(string)
  validation {
    condition     = alltrue([for o in var.public_subnets : can(cidrhost(o, 0))])
    error_message = "all elements must be valid IPv4 CIDR blocks"
  }
}
