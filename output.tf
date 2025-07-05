output "ssl_certificate" {
  description = ""
  value       = data.dnsimple_certificate.ssl_certificate
  sensitive   = true
}

output "certificate_expires_at" {
  description = "Expiration date and time of the SSL certificate"
  value       = local.certificate_expires_at
}
