
#  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet
#  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet

module "droplet_postgresql"  {
 source             = "../omnileads-digitalocean/modules/droplet"
 image_name         = var.img_centos
 name               = var.name_pgsql
 tenant             = var.tenant
 environment        = var.environment
 region             = var.region
 ssh_keys           = [var.ssh_key_fingerprint]
 vpc_uuid           = module.vpc.id
 droplet_size       = var.droplet_postgresql_size
 monitoring         = false
 private_networking = true
 ipv6               = false
 user_data          = templatefile("../omnileads-digitalocean/templates/postgresql.tpl", {
   database_name            = var.pg_database
   omlapp_user              = var.pg_username
   omlapp_password          = var.pg_password
 })
}

# Firewall aplicado al droplet POSTGRESQL # Firewall aplicado al droplet POSTGRESQL
# Firewall aplicado al droplet POSTGRESQL # Firewall aplicado al droplet POSTGRESQL


resource "digitalocean_firewall" "fw_postgresql" {
  name = var.name_pgsql

  droplet_ids = [module.droplet_postgresql.id[0]]


  inbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    source_addresses      = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol              = "tcp"
    port_range            = "5432"
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


  # module "pgsql"  {
  #   source        = "../omnileads-digitalocean/modules/db"
  #   name          = var.name_pgsql
  #   tenant        = var.tenant
  #   environment   = var.environment
  #   engine        = "pg"
  #   db_version    = "11"
  #   size          = var.pgsql_size
  #   region        = var.region
  #   vpc_id        = module.vpc.id
  # }
  #
  # resource "digitalocean_database_user" "omnileads" {
  #   cluster_id = module.pgsql.database_id
  #   name       = var.pg_username
  # }
  #
  # resource "digitalocean_database_db" "database-example" {
  #   cluster_id = module.pgsql.database_id
  #   name       = var.pg_database
  # }
  #
  # # Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL
  # # Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL
  #
  # resource "digitalocean_database_firewall" "pgsql-fw" {
  #   cluster_id = module.pgsql.database_id
  #
  #   rule {
  #     type  = "droplet"
  #     value = module.droplet_omlapp.id[0]
  #   }
  # }
