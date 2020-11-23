
provider "digitalocean" {
  # You need to set this in your .bashrc
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"
  #
}

module "vpc" {
  source      = "./../terraform-digitalocean-vpc"
  name        = "vpc"
  application = var.app
  environment = var.env
  label_order = ["environment", "application", "name"]
  enable_vpc  = true
  region      = var.region
  ip_ragne    = var.vpc_cidr
}

module "droplet" {
  source             = "./../terraform-digitalocean-droplet"
  name               = var.droplet_name_rtp
  application        = var.app
  environment        = var.env
  label_order        = ["environment", "application", "name"]
  droplet_count      = var.droplet_count
  region             = var.region
  ssh_keys           = [var.ssh_id]
  vpc_uuid           = module.vpc.id
  droplet_size       = var.droplet_size
  monitoring         = false
  private_networking = true
  ipv6               = false
  floating_ip        = true
  block_storage_size = var.disk_size
  user_data          = file(var.user_data_rtp)
}

module "firewall_rtp" {
  source          = "./../digitalocean-firewall"
   name            = "fwrtp"
   application     = var.app
   environment     = var.env
   label_order     = ["environment", "application", "name"]
   enable_firewall = true
   allowed_ip      = ["0.0.0.0/0"]
   protocol        = "udp"
   allowed_ports   = ["40000-50000"]
   droplet_ids     = module.droplet.id
}
