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
		command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
	}
}

resource "random_pet" "server" {
  count     = local.numberOfInstances
  separator = "_"
}

resource "docker_image" "nodered_image" {
  # name of image
  name = var.image[terraform.workspace]
}

resource "docker_container" "nodered_container" {
  count = local.numberOfInstances
  name  = join("_", ["nodered", terraform.workspace, random_pet.server[count.index].id])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.internalPort
    external = var.externalPort[terraform.workspace][count.index]
  }
  volumes {
  	container_path = "/data"
  	host_path = "${path.cwd}/noderedvol"
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

