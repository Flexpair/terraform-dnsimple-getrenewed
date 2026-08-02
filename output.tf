output "ssl_certificate" {
  description = ""
  value       = data.dnsimple_certificate.last_expiring
  sensitive   = true
}

output "certificate_expires_at" {
  description = "The expiration date and time of the SSL certificate."
  value       = local.certificate_expires_at
}
