# terraform plan -var numberOfInstances=1
variable "image" {
type = map
description = "image for container"
default = {
  dev = "nodered/node-red:latest"
  prod = "nodered/node-red:latest-minimal"
}
}

variable "externalPort" {
  type    = map
  # default = 1880 # can also place values in *.tfvars file
  # sensitive = true
  validation {
    # cannot have vars in functions
  	condition = max(var.externalPort["dev"]...) <= 65535 && min(var.externalPort["dev"]...) > 0
  	error_message = "The external port must be between 0 and 65535 inclusive."
  }
  validation {
  	condition = max(var.externalPort["prod"]...) <= 65535 && min(var.externalPort["prod"]...) > 0
  	error_message = "The external port must be between 0 and 65535 inclusive."
  }
}
variable "internalPort" {
  type    = number
  default = 1880
  validation {
  	condition = var.internalPort == 1880
  	error_message = "The internal port must be 1880."
  }
}

locals {
  numberOfInstances = length(var.externalPort[terraform.workspace])
}
# or: export TF_VAR_numberOfInstances=2