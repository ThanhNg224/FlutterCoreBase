# CLAUDE.md

## Project Context
This is a production-grade Flutter starter application adhering strictly to **Feature-First Clean Architecture**, **Riverpod Generator (`@riverpod`)**, and **Freezed**.

---

## Source of Truth

The engineering rules live in `docs/`, not in this file. Read the relevant document **before** implementing anything, and if a rule needs to change, edit it in `docs/` — not here — so this file never drifts out of sync with the real rules.

| Read this for... | File |
| --- | --- |
| Layer boundaries, Riverpod patterns, dependency rules | `docs/ARCHITECTURE.md` |
| Design system, localization, forms, storage, error handling, logging, code quality | `docs/STANDARD.md` |
| The current inventory of `core/` (reusable widgets, utils, extensions) — check before creating anything new | `docs/CORE_MODULES.md` |
| Steps and structure for a new feature module | `docs/FEATURE_TEMPLATE.md` |
| Branching and commit conventions | `docs/GIT_FLOW.md` |

---

## Commands
- **Run build_runner:** `dart run build_runner build --delete-conflicting-outputs`
- **Analyze code:** `flutter analyze` (Must have 0 warnings/errors)
- **Run all tests:** `flutter test`
- **Run single test:** `flutter test test/path/to/test_file.dart`
