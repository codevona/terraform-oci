# Data from terraform.tfvars file
variable "tenancy_ocid" {}
variable "ssh_public_key" {}
variable "compartment_ocid" {}
variable "name" {}

# Choose an Availability
variable "AD" {
  default = "1"
}

# VCN Variables
variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

# OS Image
variable "image_operating_system" {
  default = "Canonical Ubuntu"
}

variable "image_operating_system_version" {
  default = "20.04"
}

# Compute Shape
variable "instance_shape" {
  default = "VM.Standard.E4.Flex"
}
