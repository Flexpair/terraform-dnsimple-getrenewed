terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "~> 1.8.0"
    }
  }
  required_version = "~> 1.12.0"
}
