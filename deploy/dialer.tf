#  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet
#  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet #  DIALER componenet

  module "droplet_wombat"  {
   source             = "../modules/droplet"
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
   user_data          = templatefile("./templates/dialer.tpl", {
     mysql_host                = module.droplet_mariadb.ipv4_address_private
     mysql_database            = var.wombat_database
     mysql_username            = var.wombat_database_username
     mysql_password            = var.wombat_database_password
   })
  }

  # Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT
  # Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT


  resource "digitalocean_firewall" "fw_wombat" {
    name = var.name_wombat

    droplet_ids = [module.droplet_wombat.id[0]]


    inbound_rule {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0"]
    }

    inbound_rule {
      protocol            = "tcp"
      port_range          = "8080"
      source_addresses = ["0.0.0.0/0"]
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
