# Agent Guide — `terraform-dnsimple-getrenewed`

Data-only Terraform module: retrieves the most recently issued TLS certificate for a subdomain from
DNSimple. **Creates no resources** — it exposes the latest certificate and its expiration time for
Flexpair deployments.

## How AI agents load these instructions

This `AGENTS.md` is the **single canonical, tool-independent source** of agent guidance for this
repository. It is read natively by both GitHub Copilot and Claude Code, so keep durable rules here
rather than duplicating them elsewhere.

- `.github/copilot-instructions.md` is a thin pointer to this file. Do not duplicate rules into it.
- This module is a Git submodule of the Flexpair umbrella repository; cross-cutting rules live in
  the umbrella `AGENTS.md`.

### Scoped rules

- `@.github/instructions/terraform.instructions.md` — repository-wide Terraform conventions.
  Copilot applies it via `applyTo` globs; Claude Code should load it before Terraform work here.

## Tech stack and structure

- Terraform `>= 1.12.0`; providers `dnsimple/dnsimple >= 1.10.0`, `hashicorp/tls >= 4.1.0`,
  `Mastercard/restapi >= 3.0.0` (the REST provider works around `data.http` limits for the API call).
- Key files: `main.tf` (zone lookup → latest-cert query → expiry parse),
  `variables.tf` (`registered_domain`, `sub_domain_name`), `output.tf` (`ssl_certificate`
  [sensitive], `certificate_expires_at`).
- Published to the HCP private registry as `app.terraform.io/Flexpair/getrenewed/dnsimple`.

## Conventions and gotchas

- **Token is provider-level, not a module input.** v2.0.0 removed the `dnsimple_token` variable
  (required for HCP Terraform Stacks). Never reintroduce it, hardcode tokens, or land them in state;
  supply credentials via provider config / TFC secrets.
- DNSimple owns certificate renewal. The module reads the latest issued certificate on Terraform
  refresh but does not request renewal or trigger a deployment when DNSimple issues a replacement.
- `ssl_certificate` is `sensitive` and contains the private key — handle with care in any caller.
- Publish new versions per the umbrella's `terraform-registry-publishing` scoped rule.

## Build, test, validate

- No CI workflows and no `*.tftest.hcl` present. Validate locally: `terraform fmt` ·
  `terraform validate` · `tflint`. A devcontainer (`.devcontainer/devcontainer.json`) provides the
  Terraform toolchain.
