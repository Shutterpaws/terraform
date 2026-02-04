resource "cloudflare_dns_record" "cherry" {
  zone_id = cloudflare_zone.shutterpaws_pics.id
  name    = "cherry.shutterpaws.pics"
  type    = "CNAME"
  content = "shutterpaws.pics"
  ttl     = 1
  proxied = true
}
