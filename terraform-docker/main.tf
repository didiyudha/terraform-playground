# Set the required provider and versions.
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

# Configure the docker provider.
provider "docker" {}

# Pull docker image.
resource "docker_image" "nodered" {
  name         = "nodered/node-red:latest"
  keep_locally = true
}

# Run docker container
resource "docker_container" "nodered" {
  name  = "nodered"
  image = docker_image.nodered.latest

  ports {
    internal = 1880
    external = 1880
  }
}

resource "docker_container" "nodered-2" {
  name  = join("-", ["nodered", random_string.randomstr.result])
  image = docker_image.nodered.latest

  ports {
    internal = 1880
  }
}

# Random string.
resource "random_string" "randomstr" {
  length  = 4
  special = false
  upper   = false
}

# Print container ip address
output "nodered_ip" {
  value       = docker_container.nodered.ip_address
  description = "The IP address of the nodered container"
}

# Print container name
output "nodered_container_name" {
  value       = docker_container.nodered.name
  description = "The container name of the nodered container"
}

output "nodered_2_container_name" {
  value       = docker_container.nodered-2.name
  description = "The container name of the nodered 2 container"
}

output "nodered_address" {
  value       = join(":", [docker_container.nodered.ip_address, docker_container.nodered.ports[0].external])
  description = "Nodered address"
}