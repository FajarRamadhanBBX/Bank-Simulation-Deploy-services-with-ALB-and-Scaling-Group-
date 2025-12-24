variable "vpc_id" {
    type = string
    default = output.vpc_id
}

variable "alb_sg_id" {
    type = string
    default = output.alb_sg_id
}

variable "public_subnet_ids" {
    type = list(string)
    default = output.public_subnet_ids
}