## Managed By : CloudDrove
##Description : This Script is used to create VPC.
## Copyright @ CloudDrove. All Right Reserved.

# tags tags tags tags tags tags tags tags
# tags tags tags tags tags tags tags tags
resource "digitalocean_tag" "tenant" {
  name = var.tenant
}
resource "digitalocean_tag" "environment" {
  name = var.environment
}

#Module      : VPC
#Description : VPCs are virtual networks containing resources that can communicate with each other in full isolation, using private IP addresses.
resource "digitalocean_vpc" "default" {
  count = var.enable_vpc == true ? 1 : 0

  name        = var.name
  region      = var.region
  ip_range    = var.ip_range
  description = var.description
}
