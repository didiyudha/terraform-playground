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

# Random string.
resource "random_string" "randomstr" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}

# Run docker container
resource "docker_container" "nodered" {
  count = 2
  name  = join("-", ["nodered", random_string.randomstr[count.index].result])
  image = docker_image.nodered.latest

  ports {
    internal = 1880
  }
}

# Print nodered container-1 address
output "nodered1_address" {
  value       = join(":", [docker_container.nodered[0].ip_address, docker_container.nodered[0].ports[0].internal])
  description = "nodered-1 address"
}