#  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet
#  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet

  module "droplet_kamailio"  {
   source             = "../omnileads-digitalocean/modules/droplet"
   image_name         = var.img_centos
   name               = var.name_kamailio
   tenant             = var.tenant
   environment        = var.environment
   region             = var.region
   ssh_keys           = [var.ssh_key_fingerprint]
   vpc_uuid           = module.vpc.id
   droplet_size       = var.droplet_kamailio_size
   monitoring         = false
   private_networking = true
   ipv6               = false
   user_data          = templatefile("../omnileads-digitalocean/templates/kamailio.tpl", {
     rtpengine_host            = module.droplet_rtpengine.ipv4_address_private
     redis_host                = module.droplet_redis.ipv4_address_private
     kamailio_pkg_size         = var.kamailio_pkg_size
     kamailio_shm_size         = var.kamailio_shm_size
   })
  }

  # Firewall aplicado al droplet KAMAILIO # Firewall aplicado al droplet KAMAILIO
  # Firewall aplicado al droplet KAMAILIO # Firewall aplicado al droplet KAMAILIO


  resource "digitalocean_firewall" "fw_kamailio" {
    name = var.name_kamailio

    droplet_ids = [module.droplet_kamailio.id[0]]


    inbound_rule {
      protocol              = "tcp"
      port_range            = "22"
      source_addresses      = ["0.0.0.0/0"]
    }

    inbound_rule {
      protocol              = "tcp"
      port_range            = "14443"
      source_addresses      = ["0.0.0.0/0"]
    }

    inbound_rule {
      protocol              = "udp"
      port_range            = "5060"
      source_addresses      = ["0.0.0.0/0"]
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
    protocol                = "icmp"
    destination_addresses   = ["0.0.0.0/0", "::/0"]
    }

  }
