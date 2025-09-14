data "dnsimple_zone" "selected" {
  name = var.registered_domain
}

data "http" "certs" {
  url = "https://api.dnsimple.com/v2/${data.dnsimple_zone.selected.account_id}/domains/${var.registered_domain}/certificates?sort=expiration:desc"

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

data "dnsimple_certificate" "last_expiring" {
  domain         = var.registered_domain
  certificate_id = local.last_expiring.id
}

data "tls_certificate" "server_certificate" {
  content = data.dnsimple_certificate.last_expiring.server_certificate
}

locals {
  certificate_expires_at  = data.tls_certificate.server_certificate.certificates[0].not_after
  require_validity_until  = timeadd(timestamp(), "2016h") # 12 weeks
  require_new_certificate = timecmp(local.certificate_expires_at, local.require_validity_until) < 0
}
