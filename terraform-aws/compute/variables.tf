# --- compute/variables.tf ---

variable "instance_type" {}
variable "instance_count" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "vol_size" {}
variable "key_name" {}
variable "public_key_path" {}
variable "user_data_path" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "db_endpoint" {}
variable "lb_target_group_arn" {}
variable "tg_port" {}
variable "private_key_path" {}