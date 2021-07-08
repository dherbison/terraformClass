output "Container-Name" {
  value       = docker_container.nodered_container[*].name
  description = "The Name of the container"
}
output "Container-IP-Address" {
  value       = docker_container.nodered_container[*].ip_address
  description = "The IP Address of the container"
}
# 2 ways of doing this: splat on ports and no splat on ports
output "Container-Ports-Splat" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The Ports of the container"
#  sensitive = true
}
output "Container-Ports-NoSplat" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], [i.ports[0].external])]
  description = "The Ports of the container"
#  sensitive = true
}
