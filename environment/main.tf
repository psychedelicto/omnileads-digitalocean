
  provider "digitalocean" {
  # You need to set this in your .bashrc
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"
  #
  }



  module "vpc" {
  source      = "github.com/psychedelicto/digitalocean-terraform-modules/vpc"
  #source      = "../../digitalocean-terraform-modules/vpc"
  name        = var.name
  tenant             = var.tenant
  environment        = var.environment
  enable_vpc  = true
  region      = var.region
  ip_ragne    = var.vpc_cidr
  }

  module "droplet_rtpengine" {
  source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
  #source      = "../../digitalocean-terraform-modules/droplet"
  image_name         = var.img_centos
  name               = var.name_rtpengine
  tenant             = var.tenant
  environment        = var.environment
  # droplet_count      = var.droplet_count
  region             = var.region
  ssh_keys           = [var.ssh_id]
  vpc_uuid           = module.vpc.id
  droplet_size       = var.droplet_rtp_size
  monitoring         = false
  private_networking = true
  ipv6               = false
  user_data          = templatefile("../user_data/rtpengine.tpl", {
  })
  }


  module "pgsql"  {
   source        = "github.com/psychedelicto/digitalocean-terraform-modules/db"
   #source      = "../../digitalocean-terraform-modules/db"
   name          = var.name_pgsql
   tenant             = var.tenant
   environment        = var.environment
   engine        = "pg"
   db_version    = "11"
   size          = var.pgsql_size
   region        = var.region
   vpc_id        = module.vpc.id
  }


  module "droplet_redis"  {
   source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
   #source      = "../../digitalocean-terraform-modules/droplet"
   image_name         = var.img_ubuntu
   name               = var.name_redis
   tenant             = var.tenant
   environment        = var.environment
   region             = var.region
   ssh_keys           = [var.ssh_id]
   vpc_uuid           = module.vpc.id
   droplet_size       = var.droplet_rtp_size
   monitoring         = false
   private_networking = true
   ipv6               = false
   user_data          = templatefile("../user_data/redis.tpl", {
   })

  }

  module "droplet_mariadb"  {
   source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
   #source            = "../../digitalocean-terraform-modules/droplet"
   image_name         = var.img_centos
   name               = var.name_mariadb
   tenant             = var.tenant
   environment        = var.environment
   region             = var.region
   ssh_keys           = [var.ssh_id]
   vpc_uuid           = module.vpc.id
   droplet_size       = var.droplet_rtp_size
   monitoring         = false
   private_networking = true
   ipv6               = false
   user_data          = templatefile("../user_data/mariadb.tpl", {
     mysql_username            = "wombat"
     mysql_password            = "admin123"
     })

   }

  module "droplet_wombat"  {
   source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
   #source            = "../../digitalocean-terraform-modules/droplet"
   image_name         = var.img_centos
   name               = var.name_wombat
   tenant             = var.tenant
   environment        = var.environment
   region             = var.region
   ssh_keys           = [var.ssh_id]
   vpc_uuid           = module.vpc.id
   droplet_size       = var.droplet_rtp_size
   monitoring         = false
   private_networking = true
   ipv6               = false
   user_data          = templatefile("../user_data/wombat.tpl", {
     mysql_host                = module.droplet_mariadb.ipv4_address_private
     mysql_database            = var.wombat_database
     mysql_username            = var.wombat_database_username
     mysql_password            = var.wombat_database_password
   })
  }


  module "droplet_omlapp" {
  source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
  #source            = "../../digitalocean-terraform-modules/droplet"
  image_name         = var.img_centos
  name               = var.name_omlapp
  tenant             = var.tenant
  environment        = var.environment
  # droplet_count      = var.droplet_count
  region             = var.region
  ssh_keys           = [var.ssh_id]
  vpc_uuid           = module.vpc.id
  droplet_size       = var.droplet_oml_size
  monitoring         = false
  private_networking = true
  ipv6               = false
  # floating_ip        = false
  # block_storage_size = var.disk_size
  user_data          = templatefile("../user_data/omlapp.tpl", {
    NIC                       = var.network_interface
    omlapp_hostname           = var.omlapp_hostname
    omnileads_release         = var.oml_release
    ami_user                  = var.ami_user
    ami_password              = var.ami_password
    mysql_host                = module.droplet_redis.ipv4_address_private
    dialer_host               = module.droplet_redis.ipv4_address_private
    dialer_user               = var.dialer_user
    dialer_password           = var.dialer_password
    ecctl                     = var.ecctl
    pg_host                   = module.pgsql.database_private_host
    pg_port                   = module.pgsql.database_port
    pg_database               = var.pg_database
    pg_username               = var.pg_username
    pg_password               = var.pg_password
    pg_default_database       = module.pgsql.database_name
    pg_default_user           = module.pgsql.database_user
    pg_default_password       = module.pgsql.database_password
    rtpengine_host            = module.droplet_rtpengine.ipv4_address_private
    redis_host                = module.droplet_redis.ipv4_address_private
    dialer_host               = module.droplet_wombat.ipv4_address_private
    mysql_host                = module.droplet_mariadb.ipv4_address_private
    sca                       = var.sca
    schedule                  = var.schedule
    extern_ip                 = var.extern_ip
    TZ                        = var.oml_tz
  })
  }

  module "lb" {
  source              = "github.com/psychedelicto/digitalocean-terraform-modules/loadbalancer"
  #source             = "../../digitalocean-terraform-modules/loadbalancer"
  name                = var.name_lb
  tenant             = var.tenant
  environment        = var.environment
  region              = var.region
  tls_passthrough     = true
  vpc_id              = module.vpc.id
  target_droplets     = [module.droplet_omlapp.id[0]]
  target_port         = "443"
  }
