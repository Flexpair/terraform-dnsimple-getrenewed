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
  }
  required_version = ">= 0.13"
}
