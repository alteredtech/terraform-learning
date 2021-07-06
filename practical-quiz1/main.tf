terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }
}

provider "docker" {

}

variable "int_port" {
  type    = number
  default = 3000

  validation {
    condition     = var.int_port == 3000
    error_message = "The Grafana port must be set to 3000."
  }
}

variable "ext_port" {
  type = list(any)
}

resource "docker_image" "container_image" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "container" {
  count = 2
  name  = "grafana_container-${count.index}"
  image = docker_image.container_image.latest
  ports {
    external = var.ext_port[count.index]
    internal = var.int_port
  }
}

output "public_ip" {
  value = [for x in docker_container.container : "${x.name} - ${x.ip_address}:${x.ports[0].external}"]
}