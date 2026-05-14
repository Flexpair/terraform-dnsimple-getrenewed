# terraform-dnsimple-getrenewed

[Terraform](https://en.wikipedia.org/wiki/Terraform_(software)) data-only module that retrieves the most recently issued TLS/SSL certificate for a given subdomain from [DNSimple](https://dnsimple.com/) and checks whether it is still valid long enough or needs renewal.

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
5. Compares expiration to `now + 12 weeks` and sets `require_new_certificate` accordingly

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
| `require_validity_until` | no | Required validity horizon (`now + 12 weeks`) |
| `require_new_certificate` | no | `true` if the certificate expires before the 12-week horizon |

## Requirements

| Dependency | Version |
|------------|---------|
| Terraform | `>= 1.12.0` |
| `Mastercard/restapi` | `>= 3.0.0` |
| `dnsimple/dnsimple` | `>= 1.10.0` |
| `hashicorp/tls` | `>= 4.1.0` |

## License

[Apache 2.0](https://en.wikipedia.org/wiki/Apache_License)
