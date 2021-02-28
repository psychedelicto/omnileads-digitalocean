
# tags tags tags tags tags tags tags tags
# tags tags tags tags tags tags tags tags
resource "digitalocean_tag" "tenant" {
  name = var.tenant
}
resource "digitalocean_tag" "environment" {
  name = var.environment
}

resource "digitalocean_loadbalancer" "lb" {
  name      = var.name
  region    = var.region
  vpc_uuid  = var.vpc_id

  forwarding_rule {
    tls_passthrough = var.tls_passthrough
    entry_port     = 443
    entry_protocol = "https"

    target_port     = var.target_port
    target_protocol = "https"

    certificate_name  = var.ssl_cert 
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids       = var.target_droplets
}
