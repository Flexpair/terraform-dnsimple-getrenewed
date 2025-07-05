data "http" "certs" {
  url = "https://api.dnsimple.com/v2/${var.account_id}/domains/${var.registered_domain}/certificates"

  request_headers = {
    Authorization = "Bearer ${var.dnsimple_account_token}"
    Accept        = "application/json"
  }
}

locals {
  all_certs = jsondecode(data.http.certs.response_body).data

  matching_certs = [
    for cert in local.all_certs : cert
    if cert.common_name == "*.${var.registered_domain}"
  ]

  # Find the newest by created_at
  sorted_certs = sort(local.matching_certs, [for cert in local.matching_certs : cert.created_at])
  newest_cert  = local.sorted_certs[length(local.sorted_certs) - 1]

  certificate_id = local.newest_cert.id
}


data "dnsimple_certificate" "ssl_certificate" {
  domain         = "flexpair.app" # wildcard
  certificate_id = local.certificate_id
}

