variable "ext_port_in" {
  description = "external port of container"
}

variable "int_port_in" {
  description = "internal port of container"
}

variable "count_in" {
  description = "how many containers are made"
}

variable "image_in" {
  description = "image for container"
}

variable "name_in" {
  description = "name of container"
}

variable "sudo_pass_in" {
  description = "sudo password"
}

variable "volumes_in" {
  description = "path for all the volumes in the container"
}
