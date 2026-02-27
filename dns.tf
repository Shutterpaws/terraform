resource "cloudflare_dns_record" "cherry" {
  zone_id = cloudflare_zone.shutterpaws_pics.id
  name    = "cherry"
  type    = "CNAME"
  content = "shutterpaws.pics"
  ttl     = 1
  proxied = true
}

# AT Protocol (Bluesky) domain verification
resource "cloudflare_dns_record" "atproto" {
  zone_id = cloudflare_zone.shutterpaws_pics.id
  name    = "_atproto"
  type    = "TXT"
  content = "did=did:plc:dlvk7r4qizufe2vrmrfgtn62"
  ttl     = 3600
}
