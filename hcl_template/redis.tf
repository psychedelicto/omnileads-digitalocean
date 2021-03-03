#  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet
#  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet #  REDIS componenet

  module "droplet_redis"  {
    source             = "../omnileads-digitalocean/modules/droplet"
    image_name         = var.img_docker
    name               = var.name_redis
    tenant             = var.tenant
    environment        = var.environment
    region             = var.region
    ssh_keys           = [var.ssh_key_fingerprint]
    vpc_uuid           = module.vpc.id
    droplet_size       = var.droplet_rtp_size
    monitoring         = false
    private_networking = true
    ipv6               = false
    user_data          = templatefile("../omnileads-digitalocean/templates/redis.sh", {
   })
  }

  # Firewall aplicado al cluster REDIS # Firewall aplicado al cluster REDIS
  # Firewall aplicado al cluster REDIS # Firewall aplicado al cluster REDIS

  resource "digitalocean_firewall" "fw_redis" {
    name = var.name_redis

    droplet_ids = [module.droplet_redis.id[0]]


    inbound_rule {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    }

    inbound_rule {
      protocol            = "tcp"
      port_range          = "6379"
      source_droplet_ids  = [module.droplet_omlapp.id[0],module.droplet_kamailio.id[0]]
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
