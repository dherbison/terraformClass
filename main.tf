terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.11.0"
      # OLD WAY min TF version to use
      #source  = "terraform-provider/docker"
      #version = "~> 2.7.2"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol" {
	provisioner "local-exec" {
		command = "mkdir ~/environment/noderedvol/ || true && sudo chown -R 1000:1000 ~/environment/noderedvol/"
	}
}

resource "random_pet" "server" {
  count     = var.numberOfInstances
  length    = 2
  separator = "_"
}

resource "docker_image" "nodered_image" {
  # name of image
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  count = var.numberOfInstances
  name  = join("_", ["nodered", random_pet.server[count.index].id])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.internalPort
    external = var.externalPort
  }
  volumes {
  	container_path = "/data"
  	host_path = "/home/ubuntu/environment/noderedvol"
  }
}

# terraform import code start
# ran: terraform import docker_container.nodered_container $(docker inspect --format="{{.ID}}" nodered_generous-termite)
# resource "docker_container" "nodered_container" {
#   name  = "nodered_generous-termite"
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     #    external = 1880
#   }
# }
# terraform import code end

