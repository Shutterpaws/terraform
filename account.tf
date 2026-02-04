resource "cloudflare_account" "shutterpaws" {
  name = "Hyper123@gmail.com's Account"
  type = "standard"

  settings = {
    enforce_twofactor = true
  }
}
