output "ssl_certificate" {
  description = ""
  value       = data.dnsimple_certificate.ssl_certificate
  sensitive   = true
}