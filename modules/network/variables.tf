variable "vpc_name" {
  description = "Name of VPC identifier"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIRD range for VPC, with the default value total number of allowed host will be 65,531"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIRD range for private subnets, with the default value total number of allowed host will be 251"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "CIRD range for public subnets, with the default value total number of allowed host will be 251"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}


