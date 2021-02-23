#  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet
#  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet #  MARIADB componenet

  module "droplet_mariadb"  {
   source             = "github.com/psychedelicto/oml-mysql/deploy/digitalocean/infra/"
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
   user_data          = templatefile("./.terraform/modules/droplet_mariadb/deploy/digitalocean/cloud-init/user_data.tpl", {
     mysql_username            = var.wombat_database_username
     mysql_password            = var.wombat_database_password
     })
   }

   # Firewall aplicado MARIADB # Firewall aplicado MARIADB
   # Firewall aplicado MARIADB # Firewall aplicado MARIADB

   resource "digitalocean_firewall" "fw_mariadb" {
     name = var.name_mariadb

     droplet_ids = [module.droplet_wombat.id[0]]


     inbound_rule {
       protocol         = "tcp"
       port_range       = "22"
       source_addresses = ["0.0.0.0/0"]
     }

     inbound_rule {
       protocol            = "tcp"
       port_range          = "3306"
       source_droplet_ids  = [module.droplet_wombat.id[0]]
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
