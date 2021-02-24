terraform {
    required_version = ">= 0.14"

    required_providers {
      digitalocean = {
        source      = "digitalocean/digitalocean"
        version     = ">1.22.2"
      }
    }

# uncomment if you want to save tfstate on digitalocean spaces - S3
    backend "s3" {
      bucket                      = "omnileads" #Your tenant string identifier
      key                         = "customer-terraform.tfstate" #Your tenant tfstate string identifier
      region                      = "us-east-1" #AWS S3 region
      endpoint                    = "sfo3.digitaloceanspaces.com" #Your Spaces URL
      access_key                  = "A6SLI4WGFIKN2XPF52QA" #Your Spaces access key
      secret_key                  = "SY2CXtszQztoymzM3rDuAdCCfTjWx4Ah2p1F4aGLvB0" #Your Spaces secret key
      skip_credentials_validation = true
      skip_metadata_api_check     = true
    }

}

provider "digitalocean" {}
