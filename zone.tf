resource "cloudflare_zone" "shutterpaws_pics" {
  name = "shutterpaws.pics"

  account = {
    id = cloudflare_account.shutterpaws.id
  }
}
