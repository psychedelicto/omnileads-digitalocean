#  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet
#  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet #  OMLAPP componenet

  module "droplet_omlapp" {
  source                      = "../omnileads-digitalocean/modules/droplet"
  image_name                  = var.img_centos
  name                        = var.name_omlapp
  tenant                      = var.tenant
  environment                 = var.environment
  # droplet_count      = var.droplet_count
  region                      = var.region
  ssh_keys                    = [ssh_key_fingerprint]
  vpc_uuid                    = module.vpc.id
  droplet_size                = var.droplet_oml_size
  monitoring                  = false
  private_networking          = true
  ipv6                        = false
  # floating_ip        = false
  # block_storage_size = var.disk_size
  user_data                   = templatefile("../omnileads-digitalocean/templates/omlapp.tpl", {
    NIC                           = var.network_interface
    omlapp_hostname               = var.omlapp_hostname
    omnileads_release             = var.oml_release
    ami_user                      = var.ami_user
    ami_password                  = var.ami_password
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
    spaces_key                    = var.spaces_key
    spaces_secret_key             = var.spaces_secret_key
    spaces_bucket_name            = var.spaces_bucket_name
    spaces_bucket_tenant          = var.tenant
    recording_ramdisk_size        = var.recording_ramdisk_size
    deploy_type                   = "cluster_dialer"
    })
  }

  # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
  # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp

  resource "digitalocean_tag" "tenant" {
    name = var.tenant
  }
  resource "digitalocean_tag" "environment" {
    name = var.environment
  }

  resource "digitalocean_firewall" "fw_omlapp" {
    name = var.name_omlapp

    droplet_ids = [module.droplet_omlapp.id[0]]

    inbound_rule {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    }

    inbound_rule {
      protocol                  = "tcp"
      port_range                = "443"
      source_load_balancer_uids = [module.lb.lb_id]
    }

    inbound_rule {
      protocol                  = "tcp"
      port_range                = "5038"
      source_droplet_ids        = [module.droplet_wombat.id[0]]
    }

    dynamic "inbound_rule" {
      iterator = sip_allowed_ip
      for_each = var.sip_allowed_ip
      content {
        port_range       = "5161"
        protocol         = "udp"
        source_addresses = var.sip_allowed_ip
      }
    }

    dynamic "inbound_rule" {
      iterator = sip_allowed_ip
      for_each = var.sip_allowed_ip
      content {
        port_range       = "40000-50000"
        protocol         = "udp"
        source_addresses = var.sip_allowed_ip
      }
    }

    outbound_rule {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
    }
  }
