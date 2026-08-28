# GitHub Copilot Instructions for FlutterCoreBase

## Source of Truth
Read `docs/` before implementing. This file is intentionally short and does not restate the rules that live there, so it can't drift out of sync — if a rule changes, it changes in `docs/`, not here.

- `docs/ARCHITECTURE.md` — Feature-First layer boundaries, Riverpod Generator patterns, dependency rules.
- `docs/STANDARD.md` — design system, localization, forms, storage, error handling, logging, and code quality (the authoritative rulebook).
- `docs/CORE_MODULES.md` — the current inventory of `core/` (reusable widgets, utils, extensions). Check this before creating any new widget or helper.
- `docs/GIT_FLOW.md` — branching and commit conventions.

## Verification
- Code generation: `dart run build_runner build --delete-conflicting-outputs`.
- Analysis: `flutter analyze` must have 0 warnings.
- Tests: `flutter test`.
