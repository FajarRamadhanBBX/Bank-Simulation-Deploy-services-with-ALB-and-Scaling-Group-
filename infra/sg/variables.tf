variable "vpc_id" {
    type = string
    default = output.vpc_id
}

variable "ip_internet" {
    type = string
    default = "0.0.0.0/0"
}