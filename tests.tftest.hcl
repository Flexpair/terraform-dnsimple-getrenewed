run "matching_certs" {
  command = plan

  variables {
    dnsimple_account_id = "124454"
    registered_domain   = "flexpair.app"
    sub_domain_name     = "*"
  }

  # Check that at least one matching certificate was found
  assert {
    condition     = length(local.matching_certs) >= 1
    error_message = "Found no matching certificate for this name."
  }

  # Newest certificate must expire ≥ 30 days in the future
  assert {
    condition = timecmp(
      local.last_expiring.expires_at,
      timeadd(timestamp(), "720h") # current moment + 30 days
    ) >= 0
    error_message = "Newest certificate expires in less than 30 days."
  }

}
