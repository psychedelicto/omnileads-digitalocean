
#  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet
#  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet #  PGSQL componenet

  module "pgsql"  {
    source        = "../omnileads-digitalocean/modules/db"
    name          = var.name_pgsql
    tenant        = var.tenant
    environment   = var.environment
    engine        = "pg"
    db_version    = "11"
    size          = var.pgsql_size
    region        = var.region
    vpc_id        = module.vpc.id
  }

  resource "digitalocean_database_user" "omnileads" {
    cluster_id = module.pgsql.database_id
    name       = var.pg_username
  }

  resource "digitalocean_database_db" "database-example" {
    cluster_id = module.pgsql.database_id
    name       = var.pg_database
  }

  # Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL
  # Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL

  resource "digitalocean_database_firewall" "pgsql-fw" {
    cluster_id = module.pgsql.database_id

    rule {
      type  = "droplet"
      value = module.droplet_omlapp.id[0]
    }
  }
