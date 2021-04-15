# OMLAPP user_data OMLAPP user_data OMLAPP user_data OMLAPP user_data OMLAPP user_data OMLAPP user_data
# OMLAPP user_data OMLAPP user_data OMLAPP user_data OMLAPP user_data OMLAPP user_data OMLAPP user_data

data "template_file" "omlapp" {
  template = file("../omnileads-digitalocean/templates/omlapp.tpl")
  vars = {
    NIC                           = var.network_interface
    omlapp_hostname               = var.omlapp_hostname
    omnileads_release             = var.oml_release
    ami_user                      = var.ami_user
    ami_password                  = var.ami_password
    dialer_user                   = var.dialer_user
    dialer_password               = var.dialer_password
    ecctl                         = var.ecctl
    pg_host                       = module.droplet_postgresql.ipv4_address_private
    pg_port                       = "5432"
    pg_database                   = var.pg_database
    pg_username                   = var.pg_username
    pg_password                   = var.pg_password
    rtpengine_host                = module.droplet_rtpengine.ipv4_address_private
    redis_host                    = "NULL"
    dialer_host                   = "NULL"
    mysql_host                    = "NULL"
    kamailio_host                 = "NULL"
    asterisk_host                 = "NULL"
    websocket_host                = "NULL"
    sca                           = var.sca
    schedule                      = var.schedule
    extern_ip                     = var.extern_ip
    TZ                            = var.oml_tz
    spaces_key                    = var.spaces_key
    spaces_secret_key             = var.spaces_secret_key
    spaces_bucket_name            = var.spaces_bucket_name
    spaces_bucket_tenant          = var.tenant
    recording_ramdisk_size        = var.recording_ramdisk_size
  }
}

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
  ssh_keys                    = [var.ssh_key_fingerprint]
  vpc_uuid                    = module.vpc.id
  droplet_size                = var.droplet_oml_size
  monitoring                  = false
  private_networking          = true
  ipv6                        = false
  user_data                   = data.template_file.omlapp.rendered
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

    ############ INBOUND ######################
    # SSH all
    inbound_rule {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    }
    # Web App all
    inbound_rule {
      protocol                  = "tcp"
      port_range                = "443"
      source_load_balancer_uids = [module.lb.lb_id]
    }
    # WOMBAT all
    inbound_rule {
      protocol            = "tcp"
      port_range          = "8080"
      source_addresses = ["0.0.0.0/0"]
    }
    # SIP trunks ASTERISK
    dynamic "inbound_rule" {
      iterator = sip_allowed_ip
      for_each = var.sip_allowed_ip
      content {
        port_range       = "5161"
        protocol         = "udp"
        source_addresses = var.sip_allowed_ip
      }
    }
    # RTP trunks ASTERISK
    dynamic "inbound_rule" {
      iterator = sip_allowed_ip
      for_each = var.sip_allowed_ip
      content {
        port_range       = "40000-50000"
        protocol         = "udp"
        source_addresses = var.sip_allowed_ip
      }
    }
    ############ OUTBOUND ######################
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