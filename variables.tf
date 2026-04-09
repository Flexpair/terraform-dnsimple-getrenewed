variable "registered_domain" {
  description = "The registered domain name in DNSimple (e.g. flexpair.app)"
  type        = string
}

variable "sub_domain_name" {
  description = "Subdomain prefix to match (e.g. * for wildcard)"
  type        = string
}

variable "dnsimple_token" {
  description = "DNSimple API token. Only needed when the caller does not configure the restapi provider externally (e.g. in TFC module tests)."
  type        = string
  default     = null
  sensitive   = true
}
