# terraform plan -var numberOfInstances=1
variable "numberOfInstances" {
  type    = number
  default = 1
}
variable "externalPort" {
  type    = number
  default = 1880 # can also place values in *.tfvars file
#  sensitive = true
  validation {
  	condition = var.externalPort <= 65535 && var.externalPort > 0
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

# or: export TF_VAR_numberOfInstances=2