output "ssl_certificate" {
  description = ""
  value       = data.dnsimple_certificate.last_expiring
  sensitive   = true
}

output "certificate_expires_at" {
  description = "The expiration date and time of the SSL certificate."
  value       = local.certificate_expires_at
}

output "require_validity_until" {
  description = "The date and time until we want a valid certificate."
  value       = local.require_validity_until
}

output "require_new_certificate" {
  description = "Whether a new certificate is required based on the expiration date."
  value       = local.require_new_certificate
}
