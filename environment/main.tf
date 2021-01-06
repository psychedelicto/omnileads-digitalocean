
  provider "digitalocean" {
  # You need to set this in your .bashrc
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"
  #
  }

#  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet
#  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet

  module "vpc" {
  source              = "github.com/psychedelicto/digitalocean-terraform-modules/vpc"
  name                = var.name
  tenant              = var.tenant
  environment         = var.environment
  enable_vpc          = true
  region              = var.region
  ip_range            = var.vpc_cidr
  }

#  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet
#  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet

  module "droplet_rtpengine" {
  source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
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

#  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet
#  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet

  module "pgsql"  {
   source        = "github.com/psychedelicto/digitalocean-terraform-modules/db"
   name          = var.name_pgsql
   tenant        = var.tenant
   environment   = var.environment
   engine        = "pg"
   db_version    = "11"
   size          = var.pgsql_size
   region        = var.region
   vpc_id        = module.vpc.id
  }

#  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet
#  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet

  module "droplet_redis"  {
    source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
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

#  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet
#  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet

  resource "digitalocean_volume" "recordings" {
    region                  = var.region
    name                    = var.recording_device
    size                    = var.disk_recording_size
    initial_filesystem_type = "ext4"
    description             = "recordings"
  }

  module "droplet_recordings"  {
    source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
    image_name         = var.img_ubuntu
    name               = var.name_nfs_recordings
    tenant             = var.tenant
    environment        = var.environment
    region             = var.region
    ssh_keys           = [var.ssh_id]
    vpc_uuid           = module.vpc.id
    droplet_size       = var.droplet_rtp_size
    monitoring         = false
    private_networking = true
    ipv6               = false
    user_data          = templatefile("../user_data/nfs_recordings.tpl", {
      dev_name           = var.recording_device
      nfs_clients        = var.vpc_cidr
      })
  }

  resource "digitalocean_volume_attachment" "nfs_recordings" {
    droplet_id = module.droplet_recordings.id[0]
    volume_id  = digitalocean_volume.recordings.id
  }

#  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet
#  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet

  module "droplet_mariadb"  {
   source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
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

#  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet
#  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet

  module "droplet_wombat"  {
   source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
   image_name         = var.img_centos
   name               = var.name_wombat
   tenant             = var.tenant
   environment        = var.environment
   region             = var.region
   ssh_keys           = [var.ssh_id]
   vpc_uuid           = module.vpc.id
   droplet_size       = var.droplet_dialer_size
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


#  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet
#  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet

  module "droplet_omlapp" {
  source                      = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
  image_name                  = var.img_centos
  name                        = var.name_omlapp
  tenant                      = var.tenant
  environment                 = var.environment
  # droplet_count      = var.droplet_count
  region                      = var.region
  ssh_keys                    = [var.ssh_id]
  vpc_uuid                    = module.vpc.id
  droplet_size                = var.droplet_oml_size
  monitoring                  = false
  private_networking          = true
  ipv6                        = false
  # floating_ip        = false
  # block_storage_size = var.disk_size
  user_data                   = templatefile("../user_data/omlapp.tpl", {
    NIC                           = var.network_interface
    omlapp_hostname               = var.omlapp_hostname
    omnileads_release             = var.oml_release
    ami_user                      = var.ami_user
    ami_password                  = var.ami_password
    mysql_host                    = module.droplet_redis.ipv4_address_private
    dialer_host                   = module.droplet_redis.ipv4_address_private
    dialer_user                   = var.dialer_user
    dialer_password               = var.dialer_password
    ecctl                         = var.ecctl
    pg_host                       = module.pgsql.database_private_host
    pg_port                       = module.pgsql.database_port
    pg_database                   = var.pg_database
    pg_username                   = var.pg_username
    pg_password                   = var.pg_password
    pg_default_database           = module.pgsql.database_name
    pg_default_user               = module.pgsql.database_user
    pg_default_password           = module.pgsql.database_password
    rtpengine_host                = module.droplet_rtpengine.ipv4_address_private
    redis_host                    = module.droplet_redis.ipv4_address_private
    dialer_host                   = module.droplet_wombat.ipv4_address_private
    mysql_host                    = module.droplet_mariadb.ipv4_address_private
    sca                           = var.sca
    schedule                      = var.schedule
    extern_ip                     = var.extern_ip
    TZ                            = var.oml_tz
    nfs_recordings_ip             = module.droplet_recordings.ipv4_address_private
    recording_ramdisk_size        = var.recording_ramdisk_size
  })
  }


#  LOADBALANCER componenet LOADBALANCER componenet LOADBALANCER componenet LOADBALANCER componenet
#  LOADBALANCER componenet LOADBALANCER componenet LOADBALANCER componenet LOADBALANCER componenet

resource "digitalocean_certificate" "omlcert" {
  name                        = var.omlapp_hostname
  type                        = "lets_encrypt"
  domains                     = [var.omlapp_hostname]
}

module "lb" {
  source                      = "github.com/psychedelicto/digitalocean-terraform-modules/loadbalancer"
  name                        = var.name_lb
  tenant                      = var.tenant
  environment                 = var.environment
  region                      = var.region
  tls_passthrough             = false
  vpc_id                      = module.vpc.id
  target_droplets             = [module.droplet_omlapp.id[0]]
  target_port                 = "443"
  ssl_cert                    = digitalocean_certificate.omlcert.name
}

resource "digitalocean_record" "omlapp_lb" {
  domain                      = var.domain_name
  type                        = "A"
  name                        = var.omlapp_hostname
  value                       = module.lb.lb_ip
}
