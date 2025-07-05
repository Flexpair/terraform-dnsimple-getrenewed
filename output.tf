output "ssl_certificate" {
  description = ""
  value       = data.dnsimple_certificate.ssl_certificate
  sensitive   = true
}
output "cert_expiry_date" {
  description = "Expiration date of the SSL certificate"
  value       = local.last_expiring.expires_on
}
