
output "application_access" {
  value       = [for i in module.container[*] : i]
  description = "The name and socket for each application."
}