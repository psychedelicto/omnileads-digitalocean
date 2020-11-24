#
# resource "digitalocean_database_cluster" "oml-psql" {
#   name       = var.env
#   engine     = "pg"
#   version    = "11"
#   size       = "db-s-1vcpu-1gb"
#   region     = "tor1"
#   node_count = 1
# }
#
# resource "digitalocean_database_cluster" "oml-redis" {
#   name       = var.env
#   engine     = "redis"
#   version    = "5"
#   size       = "db-s-1vcpu-1gb"
#   region     = "tor1"
#   node_count = 1
# }
#
# module "droplet_omlapp" {
#   source             = "github.com/psychedelicto/terraform-digitalocean-droplet"
#   name               = var.droplet_name_omlapp
#   application        = var.app
#   environment        = var.env
#   label_order        = ["environment", "application", "name"]
#   droplet_count      = var.droplet_count
#   region             = var.region
#   ssh_keys           = [var.ssh_id]
#   vpc_uuid           = module.vpc.id
#   droplet_size       = var.droplet_size
#   monitoring         = false
#   private_networking = true
#   ipv6               = false
#   floating_ip        = true
#   block_storage_size = var.disk_size
#   user_data          = file(var.user_data_omlapp)
# }
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
