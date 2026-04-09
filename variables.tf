variable "registered_domain" {
  description = "The registered domain name in DNSimple (e.g. flexpair.app)"
  type        = string
}

variable "sub_domain_name" {
  description = "Subdomain prefix to match (e.g. * for wildcard)"
  type        = string
}
