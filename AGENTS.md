# Engineering Guidelines

A Flutter application template. Feature-First Clean Architecture, Riverpod Generator, and Freezed contracts live in [Architecture](docs/ARCHITECTURE.md) and [Standards](docs/STANDARD.md).

## Workflow

- Read only the owning documents relevant to the task, then inspect current implementation, callers, and existing tests.
- Make the smallest complete change. Add infrastructure or abstractions only for a concrete requirement or failure mode.
- Work in the current branch and checkout. Do not create a branch or worktree unless explicitly requested; preserve other contributors' edits.
- Ask when unresolved intent or a tradeoff changes the work. Continue independent work while waiting.
- Handle small and tightly coupled changes directly. Delegate only when independent tracks reduce total effort; use a reviewer for high-risk changes or when requested.
- Use the smallest level in [Verification](docs/VERIFICATION.md). Test behavior, state, persistence, security, and concurrency when affected; do not add tests that merely mirror layout or styling.
- Report exact commands and results. Keep local checks, archive checks, builds, remote CI, and device evidence distinct.
- Keep rules in their owning documents and link elsewhere. Preserve active plans and decision records; keep handoff plans local under `docs/plans/` and delete them when completed.
- Follow [Git workflow](docs/GIT_FLOW.md). Do not commit, push, tag, publish, or deploy unless explicitly requested.

## Documents

- [Architecture](docs/ARCHITECTURE.md): ownership, dependencies, and data flow.
- [Verification](docs/VERIFICATION.md): risk levels, commands, side effects, and proof boundaries.
- [Git workflow](docs/GIT_FLOW.md): existing branch, commit, and release conventions.
- [Standards](docs/STANDARD.md): coding, API, error, and security contracts.
- [Core modules](docs/CORE_MODULES.md): reusable inventory and integration.
- [Feature guide](docs/FEATURE_TEMPLATE.md): adding application features.
- [Documentation rules](docs/AGENTS.md): edits under `docs/`.

## Repository invariants

- Keep widgets focused on rendering, state in Riverpod controllers, business rules in domain, and platform/remote work in data.
- Preserve the design system, localization, storage, redaction, and error contracts in the owning documents.
