data "dnsimple_zone" "selected" {
  name = var.registered_domain
}

data "restapi_object" "latest_cert" {
  path         = "/v2/${data.dnsimple_zone.selected.account_id}/domains/${var.registered_domain}/certificates"
  search_key   = "common_name"
  search_value = "${var.sub_domain_name}.${var.registered_domain}"
  results_key  = "data"
  query_string = "sort=expiration:desc"
}

data "dnsimple_certificate" "last_expiring" {
  domain         = var.registered_domain
  certificate_id = data.restapi_object.latest_cert.id
}

data "tls_certificate" "server_certificate" {
  content = data.dnsimple_certificate.last_expiring.server_certificate
}

locals {
  certificate_expires_at = data.tls_certificate.server_certificate.certificates[0].not_after
}
