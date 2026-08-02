# terraform-dnsimple-getrenewed

[Terraform](https://en.wikipedia.org/wiki/Terraform_(software)) data-only module that retrieves the most recently issued TLS/SSL certificate for a given subdomain from [DNSimple](https://dnsimple.com/).

No infrastructure resources are created — this module only reads data.

## Usage

The module requires a configured `restapi` provider for DNSimple API access. The API token is passed via the provider config, which supports ephemeral values (no state leakage).

```hcl
provider "restapi" {
  uri                  = "https://api.dnsimple.com"
  write_returns_object = true

  headers = {
    "Accept" = "application/json"
  }

  bearer_token = var.dnsimple_account_token
}

module "getrenewed" {
  source            = "app.terraform.io/Flexpair/getrenewed/dnsimple"
  version           = "2.0.0"
  registered_domain = "flexpair.app"
  sub_domain_name   = "*"
}
```

## How It Works

1. Looks up the DNSimple zone for `registered_domain`
2. Queries the DNSimple REST API (via `restapi` provider) for all certificates, sorted by expiration (descending)
3. Filters to certificates matching `{sub_domain_name}.{registered_domain}`
4. Fetches the full certificate data (private key, server cert, chain) for the longest-valid match

The lookup runs whenever Terraform refreshes the module's data sources. DNSimple owns certificate
renewal; this module does not request renewals or trigger a deployment when a new certificate is
issued. Callers install the latest certificate during their normal deployment lifecycle.

## Breaking Change in v2.0.0

The `dnsimple_token` input variable has been removed. Authentication is now handled by the `restapi` provider, which receives the token in its provider config. This is required for HCP Terraform Stacks compatibility, where ephemeral tokens cannot be used in `data.http` request headers.

## Inputs

| Variable | Type | Description |
|----------|------|-------------|
| `registered_domain` | `string` | The registered domain in DNSimple (e.g. `flexpair.app`) |
| `sub_domain_name` | `string` | Subdomain prefix to match (e.g. `*` for wildcard) |

## Outputs

| Output | Sensitive | Description |
|--------|-----------|-------------|
| `ssl_certificate` | yes | Full certificate data (server cert, private key, chain, root) |
| `certificate_expires_at` | no | Certificate expiration timestamp |

## Requirements

| Dependency | Version |
|------------|---------|
| Terraform | `>= 1.12.0` |
| `Mastercard/restapi` | `>= 3.0.0` |
| `dnsimple/dnsimple` | `>= 1.10.0` |
| `hashicorp/tls` | `>= 4.1.0` |

## License

[Apache 2.0](https://en.wikipedia.org/wiki/Apache_License)
