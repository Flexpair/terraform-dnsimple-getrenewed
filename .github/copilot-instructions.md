# Copilot Instructions — `terraform-dnsimple-getrenewed`

`AGENTS.md` at the repository root is the **single canonical, tool-independent source** of agent
guidance. GitHub Copilot reads `AGENTS.md` natively, so this file stays a thin pointer to avoid
duplicated, drifting rules.

- Read [`AGENTS.md`](../AGENTS.md) before doing repository work. It covers the data-only module's
  purpose, providers, the provider-level token rule (v2.0.0 removed the `dnsimple_token` input),
  DNSimple-owned certificate renewal, and validation commands.
- Path-specific Terraform conventions live in
  [`.github/instructions/terraform.instructions.md`](instructions/terraform.instructions.md) with
  an `applyTo` glob and are referenced from `AGENTS.md`.
- This module is a Git submodule of the Flexpair umbrella repository; cross-cutting rules live in
  the umbrella `AGENTS.md`.

Do **not** copy rules into this file. If a rule should apply to agents, update `AGENTS.md` instead.
