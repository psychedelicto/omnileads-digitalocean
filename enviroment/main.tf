
provider "digitalocean" {
  # You need to set this in your .bashrc
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"
  #
}

module "vpc" {
  source      = "github.com/psychedelicto/terraform-digitalocean-vpc"
  name        = var.env
  application = var.app
  environment = var.env
  label_order = ["environment", "application", "name"]
  enable_vpc  = true
  region      = var.region
  ip_ragne    = var.vpc_cidr
}

module "droplet" {
  source             = "github.com/psychedelicto/terraform-digitalocean-droplet"
  image_name         = "centos-7-x64"
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
  floating_ip        = false
  block_storage_size = var.disk_size
  user_data          = templatefile("../user_data/rtpengine.tpl", {
  })
}

# module "firewall_rtp" {
#   source          = "github.com/psychedelicto/terraform-digitalocean-firewall"
#    name            = "fwrtp"
#    application     = var.app
#    environment     = var.env
#    label_order     = ["environment", "application", "name"]
#    enable_firewall = true
#    allowed_ip      = ["0.0.0.0/0"]
#    protocol        = "udp"
#    allowed_ports   = ["40000-50000"]
#    droplet_ids     = module.droplet.id
# }


# resource "digitalocean_database_cluster" "oml-psql" {
#   name       = var.env
#   engine     = "pg"
#   version    = "11"
#   size       = "db-s-1vcpu-1gb"
#   region     = var.region
#   node_count = 1
# }
#
# resource "digitalocean_database_cluster" "oml-redis" {
#   name       = var.env
#   engine     = "redis"
#   version    = "5"
#   size       = "db-s-1vcpu-1gb"
#   region     = var.region
#   node_count = 1
# }
#
module "droplet_omlapp" {
  source             = "github.com/psychedelicto/terraform-digitalocean-droplet"
  image_name         = "centos-7-x64"
  name               = var.droplet_name_omlapp
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
  floating_ip        = false
  block_storage_size = var.disk_size
  user_data          = templatefile("../user_data/omlapp.tpl", {
    NIC                       = "eth1"
    omnileads_release         = "release-1.11.7"
    ami_user                  = "omnileadsami"
    ami_password              = "5_MeO_DMT"
    #dialer_host               = "127.0.0.1"
    dialer_user               = "demoadmin"
    dialer_password           = "demo"
    ecctl                     = "28800"
    #mysql_host                = "127.0.0.1"
    #postgres_host             = "127.0.0.1"
    #postgres_port             = "5432"
    pg_database         = "omnileads"
    pg_username             = "omnileads"
    pg_password         = "098098ZZZ"
    #default_postgres_database = "postgres"
    #default_postgres_user     = ""
    #default_postgres_password = ""
    rtpengine_host            = module.droplet.ipv4_address_private[0]
    sca                       = "3600"
    schedule                  = "agenda"
    TZ                        = "America/Argentina/Cordoba"
  })
}

output "ipv4_address" { value = module.droplet.ipv4_address_private[0] }


#
# module "firewall" {
#   source          = "github.com/psychedelicto/terraform-digitalocean-firewall"
#    name            = "fwomlapp"
#    application     = var.app
#    environment     = var.env
#    label_order     = ["environment", "application", "name"]
#    enable_firewall = true
#    allowed_ip      = ["0.0.0.0/0"]
#    allowed_ports   = [22, 443]
#    droplet_ids     = module.droplet_omlapp.id
# }
