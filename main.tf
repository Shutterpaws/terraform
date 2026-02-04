provider "cloudflare" {
  email   = "hyper123@gmail.com"
  api_key = var.cloudflare_api_token
}

# Terraform import blocks for remote state import (Terraform 1.5+)
import {
  to = cloudflare_zone.shutterpaws_pics
  id = "e17b3230e74ebd754a021077835743df"
}

import {
  to = cloudflare_account.shutterpaws
  id = "e014655344787408dba0ad363c67d24a"
}

resource "cloudflare_zone" "shutterpaws_pics" {
  name = "shutterpaws.pics"

  account = {
    id = cloudflare_account.shutterpaws.id
  }
}

resource "cloudflare_account" "shutterpaws" {
  name = "Hyper123@gmail.com's Account"
  type = "standard"
}
