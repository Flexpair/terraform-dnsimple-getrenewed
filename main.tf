data "http" "certs" {
  url = "https://api.dnsimple.com/v2/${var.dnsimple_account_id}/domains/${var.registered_domain}/certificates?sort=expiration:desc"

  request_headers = {
    Authorization = "Bearer ${var.dnsimple_token}"
    Accept        = "application/json"
  }
}

locals {
  all_certs = jsondecode(data.http.certs.response_body).data

  common_name = "${var.sub_domain_name}.${var.registered_domain}"

  matching_certs = [for cert in local.all_certs : cert if cert.common_name == local.common_name]

  last_expiring = local.matching_certs[0]
}

# Configure the DNSimple provider
provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account_id
}

data "dnsimple_certificate" "ssl_certificate" {
  domain         = var.registered_domain
  certificate_id = local.last_expiring.id
}

