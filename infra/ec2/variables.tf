variable "private_subnet_ids" {
    type = list(string)
    default = output.private_subnet_ids
}

variable "app_sg_id" {
    type = string
    default = output.app_sg_id
}

variable "lb_target_group_arn" {
    type = string
    default = output.lb_target_group_arn
}