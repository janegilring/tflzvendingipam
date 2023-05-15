variable "vnet_size" {
  description = "Size of the new Virtual Network (Subnet Mask bits)."
}

variable "hub_peering_enabled" {
  description = "True/false if peering for hub network"
}

variable "hub_network_resource_id" {
  description = "Hub network resource id for peering "
}

variable "ipam_space" {
  description = "Space in which to create a new CIDR reservation."
}

variable "ipam_block" {
  description = "Block in which to create a new CIDR reservation."
}

variable "ipam_api_guid" {
  description = "GUID for the Exposed API on the Engine App Registration."
}

variable "ipam_app_name" {
  description = "Name of the App Service or Function running the IPAM Engine."
}


