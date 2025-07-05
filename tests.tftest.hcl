run "matching_certs" {
  command = apply

  variables {
    dnsimple_account_id = "124454"
    registered_domain   = "flexpair.app"
    sub_domain_name     = "*"
  }

  # Check that at least one matching certificate was found
  assert {
    condition     = length(local.matching_certs) > 0
    error_message = "Invalid bucket name"
  }
}
