output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "Container Name"
}

output "ip-address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "IP address of the container"
  #   sensitive = true
}