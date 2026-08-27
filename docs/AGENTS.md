# AGENTS.md

## Mission

This document defines how AI assistants and developers should contribute to this Flutter starter project. Contributions must prioritize maintainability, consistency, strict adherence to Feature-First Clean Architecture, Riverpod best practices, and long-term code quality.

---

## Engineering Documents

This repository is governed by multiple engineering documents located in `docs/`. Every implementation must follow all relevant documents instead of relying on assumptions.

| Document                       | Responsibility                                                                                                                    |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| **`docs/AGENTS.md`**           | AI workflow, engineering mindset, implementation strategy, decision making, and review process.                                  |
| **`docs/ARCHITECTURE.md`**     | Feature-First Clean Architecture, Riverpod Generator patterns, dependency boundaries, data flow, and native bridge integration. |
| **`docs/STANDARD.md`**         | Dart & Flutter coding conventions, formatting, widget design, naming rules, and code quality.                                     |
| **`docs/CORE_MODULES.md`**     | Core infrastructure (Theme, Network, Storage, Routing, Constants, Reusable Widgets).                                              |
| **`docs/FEATURE_TEMPLATE.md`** | Step-by-step guide and template structure for developing new feature modules.                                                    |
| **`docs/GIT_FLOW.md`**         | Branching strategy, commit conventions, and collaboration rules.                                                                  |

Treat these documents as the project's engineering source of truth.

---

## Core Engineering Principles

- **Understand before implementing:** Read existing code and relevant docs first.
- **Reuse before creating:** Check `core/` and existing features before introducing new components.
- **Consistency over perfection:** Follow project patterns strictly.
- **Simplicity over cleverness:** Write self-explanatory code over overly concise tricks.
- **Separation of Concerns:** Keep UI widgets dumb; state in Riverpod notifiers; business logic in domain; platform/remote in data.

---

## Mandatory Coding & Architecture Rules (Strict Enforcement)

Every AI agent and developer MUST strictly obey the following rules without exception:

1. **Design System & Styling:**
   - **Font & Typography:** The project uses **Inter** (`GoogleFonts.inter`). Always use `AppTypography.<slot>` or `Theme.of(context).textTheme.<slot>`. Never hardcode `TextStyle(fontSize: ..., fontFamily: ...)`.
   - **Colors:** Use `context.colors.<token>` (`AppSemanticColors`) for all dynamic borders, surfaces, secondary/hint texts, and status colors. Use `Theme.of(context).colorScheme` or `AppColors.primary` for brand accents. **NEVER** use raw Flutter colors like `Colors.grey`, `Colors.red`, `Colors.white`, or `Color(0xFF...)`.
   - **Spacing & Radius:** Use `AppSpacing` tokens (`xs: 4`, `s: 8`, `m: 16`, `l: 24`, `xl: 32`, `xxl: 48`) and `AppSpacing.radius*`. **NEVER** use arbitrary magic padding/radius numbers.
   - **Component Reuse:** Always check and reuse `lib/core/widgets/` (`AppButton`, `AppCard`, `AppTextField`, `AppDialog`, `AppErrorWidget`, `AsyncValueWidget`) before creating custom widgets.

2. **State Management & Dependency Injection:**
   - Always use **Riverpod Generator (`@riverpod`)**.
   - Use default `@riverpod` (auto-dispose) for screen controllers; use `@Riverpod(keepAlive: true)` for singletons/core services.
   - Keep UI widgets "dumb": UI delegates all actions to Riverpod controllers.

3. **Storage & Preferences:**
   - Always inject and use `ILocalStorageService` (`localStorageServiceProvider`).
   - All persistence keys MUST be defined in `StorageKeys` (`core/constants/storage_keys.dart`).
   - **NEVER** call `SharedPreferences.getInstance()` inside feature screens or controllers.

4. **Error Handling & Architecture:**
   - Feature structure MUST follow `domain/` -> `data/` -> `presentation/`.
   - Repositories MUST return `Future<Either<Failure, T>>` and use `ErrorHandler.guard()`.
   - Present user-facing errors with `failure.localizedMessage(l10n)` or `AppDialog`.

5. **Logging & Security:**
   - Always declare `const _log = AppLogger('<Scope>');`.
   - **NEVER** use `print()` or `debugPrint()`.
   - Never log raw sensitive values; always use `Redacted` wrappers (`Redacted.secret`, `Redacted.phone`, `Redacted.type`, etc.).

6. **Quality & Verification:**
   - Run `dart run build_runner build --delete-conflicting-outputs` after editing `@riverpod` or `@freezed` models.
   - Run `flutter analyze` (must be 0 issues) and `flutter test`.

---

## AI Workflow

For every request:
1. Understand the user's intent and business context.
2. Identify which engineering documents apply.
3. Explore existing implementations and search for similar patterns.
4. Implement the smallest complete and working solution.
5. Run `flutter analyze` and `flutter test` to ensure zero regressions.
6. Perform a thorough self-review before presenting results.

---

## Git & Commit Rules

- **No Co-author:** Never include co-author metadata (`Co-authored-by: ...`) in any commit message.
- **Logical Commits:** Keep commits focused on a single logical change.
