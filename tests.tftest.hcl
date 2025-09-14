# Configure the DNSimple provider
provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account_id
}

variables {
  registered_domain   = "flexpair.app"
  sub_domain_name     = "*"
}

run "more_than_30_days" {
  command = apply

  # Check that at least one matching certificate was found
  assert {
    condition     = length(local.matching_certs) >= 1
    error_message = "Found no matching certificate for this name."
  }

  # Retrieved certificate must expire ≥ 30 days in the future
  assert {
    condition = timecmp(
      local.certificate_expires_at,
      timeadd(timestamp(), "720h") # current moment + 30 days
    ) >= 0
    error_message = "Newest certificate expires in less than 30 days."
  }

}
