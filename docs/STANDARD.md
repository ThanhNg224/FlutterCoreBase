# STANDARD.md

## Purpose

This document defines Dart & Flutter coding standards, formatting guidelines, naming conventions, and best practices for the project.

---

## Naming Conventions

| Entity                               | Format                                                | Example                                  |
| ------------------------------------ | ----------------------------------------------------- | ---------------------------------------- |
| **Classes / Enums / Mixins**         | `PascalCase`                                          | `CatalogScreen`, `AppColors`             |
| **Variables / Functions / Methods**  | `camelCase`                                           | `themeMode`, `handleException()`         |
| **Files & Directories**              | `snake_case`                                          | `catalog_screen.dart`, `app_colors.dart` |
| **Constants**                        | `camelCase` (or `SCREAMING_SNAKE_CASE` for IDs)       | `connectTimeout`, `defaultProdToken`     |
| **Riverpod Providers**               | `camelCaseProvider`                                   | `appConfigControllerProvider`            |

---

## Flutter & Dart Best Practices

### 1. Immutability & Data Modeling
- Always use `@freezed` for domain entities and complex UI states.
- Prefer `final` fields and `const` constructors wherever possible.

### 2. Widget Construction & Performance
- Break large widgets into smaller, private or dedicated widget classes.
- Use `const` widgets to optimize Flutter element rebuild trees.
- Use `ref.watch(provider.select((s) => s.specificField))` to avoid rebuilding entire screens on minor state changes.
- Never place asynchronous side effects directly inside widget `build()` methods.

### 3. Design System & Theming
- Never hardcode raw hex colors in widgets (e.g. `Color(0xFF1E56A0)`). Reference `AppColors.primary` or `Theme.of(context).colorScheme`.
- Use `AppSpacing` tokens (`AppSpacing.s`, `AppSpacing.m`, `AppSpacing.l`) instead of arbitrary margins/paddings.
- Use `AppTypography` text styles for all text elements.

### 4. Error Handling
- Use `fpdart`'s `Either<Failure, T>` return type for repository methods.
- Use `ErrorHandler.guard()` in data sources/repositories to convert unexpected exceptions into typed `Failure` objects.
- Present human-friendly error messages on the UI layer using `failure.localizedMessage(l10n)` or `AppDialog`.

### 5. Code Quality Checklist
- **No unused imports:** Keep files clean.
- **No `print()` or `debugPrint()` statements:** Use `AppLogger` (`core/logging/`), which is silent in release by construction. Declare `const _log = AppLogger('<Scope>');` at the top of the file.
- **Never log a raw value:** Logger's `data` parameter takes `Map<String, Redacted>`. Use `Redacted.secret` / `.phone` / `.length` / `.type` / `.count` / `.flag`, and `Redacted.unredacted(v, because: ...)` for non-sensitive values.
- **Code Gen Check:** Always run `dart run build_runner build --delete-conflicting-outputs` after updating `@riverpod` or `@freezed` models.
- **Analysis:** `flutter analyze` must produce **zero warnings or errors**.
