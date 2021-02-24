
#  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet
#  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet #  VPC componenet

  module "vpc" {
  source                      = "github.com/psychedelicto/digitalocean-terraform-modules/vpc"
  name                        = var.name
  tenant                      = var.tenant
  environment                 = var.environment
  enable_vpc                  = true
  region                      = var.region
  ip_range                    = var.vpc_cidr
  }

  resource "digitalocean_spaces_bucket" "tenant" {
    name   = var.tenant
    region = var.region
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
  name                        = var.name_omlapp
  value                       = module.lb.lb_ip
}