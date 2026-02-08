resource "cloudflare_ruleset" "shutterpaws_redirect" {
  zone_id = cloudflare_zone.shutterpaws_pics.id
  name    = "default"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"
  rules = [
    {
      action      = "redirect"
      description = "Telegram Chat"
      enabled     = true
      expression  = "(http.host eq \"telegram.shutterpaws.pics\")"

      action_parameters = {
        from_value = {
          preserve_query_string = false
          status_code           = 301

          target_url = {
            value = "https://t.me/+TjpTC8lLnjlkMzlh"
          }
        }
      }
    },
    {
      action      = "redirect"
      description = "Redirect from WWW to root [Template]"
      enabled     = true
      expression  = "(http.request.full_uri wildcard r\"https://www.*\")"

      action_parameters = {
        from_value = {
          preserve_query_string = false
          status_code           = 301

          target_url = {
            expression = "wildcard_replace(http.request.full_uri, r\"https://www.*\", r\"https://$${1}\")"
          }
        }
      }
    },
    {
      action      = "redirect"
      description = "Cherry Event Redirect"
      enabled     = true
      expression  = "(http.host eq \"cherry.shutterpaws.pics\")"
      action_parameters = {
        from_value = {
          preserve_query_string = false
          status_code           = 301
          target_url = {
            value = "https://shutterpaws.pics/events/2026/03/paws-and-petals/"
          }
        }
      }
    }
  ]
}
