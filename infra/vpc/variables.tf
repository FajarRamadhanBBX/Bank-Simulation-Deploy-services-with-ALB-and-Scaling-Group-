variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
    type = list(string)
    default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "availability_zones" {
    type = list(string)
    default = ["ap-southeast-1a", "ap-southeast-1b"]
}