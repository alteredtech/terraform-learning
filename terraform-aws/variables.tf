# --- root/variables.tf ---
variable "aws_region" {
  default = "us-west-2"
  # default = "us-east-1"
}

variable "AWS_SECRET_ACCESS_KEY" {
  sensitive = true
}

variable "AWS_ACCESS_KEY_ID" {
  sensitive = true
}

variable "access_ip" {
  # type = list
}

# --- datebase variables ---
variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}