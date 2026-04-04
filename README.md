# terraform-dnsimple-getrenewed

Terraform data-only module that retrieves the most recently issued TLS/SSL certificate for a given subdomain from [DNSimple](https://dnsimple.com/) and checks whether it is still valid long enough or needs renewal.

No infrastructure resources are created — this module only reads data.

## Usage

```hcl
module "getrenewed" {
  source            = "app.terraform.io/Flexpair/getrenewed/dnsimple"
  version           = "1.1.2"
  dnsimple_token    = var.dnsimple_account_token
  registered_domain = "flexpair.app"
  sub_domain_name   = "*"
}
```

## How It Works

1. Looks up the DNSimple zone for `registered_domain`
2. Queries the DNSimple REST API for all certificates, sorted by expiration (descending)
3. Filters to certificates matching `{sub_domain_name}.{registered_domain}`
4. Fetches the full certificate data (private key, server cert, chain) for the longest-valid match
5. Compares expiration to `now + 12 weeks` and sets `require_new_certificate` accordingly

## Inputs

| Variable | Type | Sensitive | Description |
|----------|------|-----------|-------------|
| `registered_domain` | `string` | no | The registered domain in DNSimple (e.g. `flexpair.app`) |
| `sub_domain_name` | `string` | no | Subdomain prefix to match (e.g. `*` for wildcard) |
| `dnsimple_token` | `string` | yes | DNSimple API bearer token |

## Outputs

| Output | Sensitive | Description |
|--------|-----------|-------------|
| `ssl_certificate` | yes | Full certificate data (server cert, private key, chain, root) |
| `certificate_expires_at` | no | Certificate expiration timestamp |
| `require_validity_until` | no | Required validity horizon (`now + 12 weeks`) |
| `require_new_certificate` | no | `true` if the certificate expires before the 12-week horizon |

## Requirements

| Dependency | Version |
|------------|---------|
| Terraform | `>= 1.7.0` |
| `hashicorp/http` | `= 3.5.0` |
| `dnsimple/dnsimple` | `>= 1.10.0` |
| `hashicorp/tls` | `= 4.1.0` |

## License

Apache 2.0
