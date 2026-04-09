terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = ">= 1.10.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.1.0"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.12.0"
}
