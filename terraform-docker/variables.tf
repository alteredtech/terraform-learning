

variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map(any)
  #   sensitive = true

  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1900
    error_message = "The external port must be larger than 1024 and smaller than 65535."
  }
  validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "The external port must be larger than 1024 and smaller than 65535."
  }
}

locals {
  container_count = length(var.ext_port[terraform.workspace])
}

variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "sudo_pass" {
  sensitive = true
}