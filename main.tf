provider "cloudflare" {
  email   = "hyper123@gmail.com"
  api_key = var.cloudflare_api_token
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

  settings = {
    enforce_twofactor = true
  }
}
