
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
  droplet_size       = var.droplet_rtp_size
  monitoring         = false
  private_networking = true
  ipv6               = false
  floating_ip        = false
  block_storage_size = var.disk_size
  user_data          = templatefile("../user_data/rtpengine.tpl", {
  })
}
#
module "pgsql"  {
   source        = "github.com/psychedelicto/terraform-digitalocean-db"
   name          = var.name
   engine        = "pg"
   db_version    = "11"
   size          = var.pgsql_size
   region        = var.region
   vpc_id        = module.vpc.id
}

resource "digitalocean_database_firewall" "pgsql-fw" {
  cluster_id = module.pgsql.database_id

  rule {
    type  = "ip_addr"
    value = var.vpc_cidr
  }
}

# module "redis"  {
#   #source        = "github.com/psychedelicto/terraform-digitalocean-db"
#   source        = "../../terraform/terraform-digitalocean-db"
#   name          = "example-redis"
#   engine        = "redis"
#   db_version    = "5"
#   size          = var.redis_size
#   region        = var.region
# }

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
  droplet_size       = var.droplet_oml_size
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
    #mysql_host                = "127.0.0.1"
    #dialer_host               = "127.0.0.1"
    dialer_user               = "demoadmin"
    dialer_password           = "demo"
    ecctl                     = "28800"
    pg_host                   = module.pgsql.database_private_host
    pg_port                   = module.pgsql.database_port
    pg_database               = "omnileads"
    pg_username               = "omnileads"
    pg_password               = "098098ZZZ"
    pg_default_database       = module.pgsql.database_name
    pg_default_user           = module.pgsql.database_user
    pg_default_password       = module.pgsql.database_password
    rtpengine_host            = module.droplet.ipv4_address_private[0]
    sca                       = "3600"
    schedule                  = "agenda"
    TZ                        = "America/Argentina/Cordoba"
  })
}

module "lb" {
  source              = "github.com/psychedelicto/terraform-digitalocean-lb"
  name                = var.name
  region              = var.region
  tls_passthrough     = true
  vpc_id              = module.vpc.id
  target_droplets     = [module.droplet_omlapp.id[0]]
  target_port         = "443"
}
