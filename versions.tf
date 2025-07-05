terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "1.9.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
  required_version = ">= 1.7.0"
}
