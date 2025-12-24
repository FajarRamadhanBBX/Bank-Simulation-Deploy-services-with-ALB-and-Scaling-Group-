variable "vpc_id" {
  type = string
}

variable "ip_internet" {
  type    = string
  default = "0.0.0.0/0"
}