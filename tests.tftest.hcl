# dnsimple provider reads DNSIMPLE_TOKEN + DNSIMPLE_ACCOUNT from env
provider "dnsimple" {}

# restapi provider needs bearer_token explicitly (no env var support)
provider "restapi" {
  uri                  = "https://api.dnsimple.com"
  write_returns_object = true

  headers = {
    "Accept" = "application/json"
  }

  bearer_token = var.dnsimple_token
}

variables {
  registered_domain = "flexpair.app"
  sub_domain_name   = "*"
}

run "more_than_30_days" {
  command = apply

  # Retrieved certificate must expire >= 30 days in the future
  assert {
    condition = timecmp(
      local.certificate_expires_at,
      timeadd(timestamp(), "720h") # current moment + 30 days
    ) >= 0
    error_message = "Newest certificate expires in less than 30 days."
  }

}
