variable "private_subnet_ids" {
  type    = list(string)
  default = [output.private_subnet_ids[*].id]
}

variable "db_sg_id" {
  type    = string
  default = output.db_sg_id.id
}

variable "username" {
  type    = string
  default = var.db_username
}

variable "password" {
  type    = string
  default = var.db_password
}