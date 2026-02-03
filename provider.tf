terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Shutterpaws"

    workspaces {
      name = "terraform"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}
