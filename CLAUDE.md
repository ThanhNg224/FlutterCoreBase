# CLAUDE.md

## Project Context
This is a production-grade Flutter starter application adhering strictly to **Feature-First Clean Architecture**, **Riverpod Generator (`@riverpod`)**, and **Freezed**.

---

## Commands
- **Run build_runner:** `dart run build_runner build --delete-conflicting-outputs`
- **Analyze code:** `flutter analyze` (Must have 0 warnings/errors)
- **Run all tests:** `flutter test`
- **Run single test:** `flutter test test/path/to/test_file.dart`

---

## Strict Engineering Rules

### 1. Design System & Styling
- **Typography:** The app's font is **Inter** (`GoogleFonts.inter`). Use `AppTypography.<slot>` or `Theme.of(context).textTheme.<slot>`. Never hardcode `TextStyle(fontSize: ...)`.
- **Colors:** Use `context.colors.<token>` (`AppSemanticColors`) for dynamic surfaces, borders, hints, secondary text, and status colors (`statusSuccess`, `statusWarning`, `statusError`, `brandAccent`, `track`). Use `Theme.of(context).colorScheme` or `AppColors.primary` for brand accents. **NEVER** use raw colors like `Colors.grey`, `Colors.red`, `Color(0xFF...)`.
- **Spacing:** Use `AppSpacing` tokens (`xs: 4`, `s: 8`, `m: 16`, `l: 24`, `xl: 32`, `xxl: 48`), `AppSpacing.radius*`, `AppSpacing.pagePadding`. Never use arbitrary pixel numbers.
- **Component Reuse:** Always check and reuse `lib/core/widgets/` (`AppButton`, `AppCard`, `AppTextField`, `AppDialog`, `AppErrorWidget`, `AsyncValueWidget`) before creating new widgets.

### 2. Architecture & Data Flow
- Every feature module in `lib/features/<feature>/` must strictly follow 3 layers:
  - `domain/`: Entities (`@freezed`), repository interfaces (`i_<feature>_repository.dart`). Pure Dart, no Flutter UI.
  - `data/`: Datasources, DTOs, repository implementations with `ErrorHandler.guard()`.
  - `presentation/`: Riverpod controllers (`@riverpod`), screens, sub-widgets. Keep UI widgets dumb.
- Cross-cutting runtime config lives in `lib/core/config/` (`AppConfigController`). Features must not depend on each other.

### 3. State Management & DI (Riverpod Generator)
- Always use `@riverpod` annotation with code generation.
- Use default `@riverpod` (auto-dispose) for screen-level controllers.
- Use `@Riverpod(keepAlive: true)` for singletons/core services (Storage, Router, Theme, AppConfig).
- Use `ref.watch(provider.select(...))` to optimize rebuild performance.

### 4. Local Storage & Preferences
- Always inject and use `ILocalStorageService` via `ref.watch(localStorageServiceProvider)`.
- All persistence keys must be defined in `StorageKeys` (`core/constants/storage_keys.dart`).
- **NEVER** call `SharedPreferences.getInstance()` in feature code.

### 5. Error Handling
- Repositories must return `Future<Either<Failure, T>>` from `fpdart`.
- Use `ErrorHandler.guard()` to wrap async calls.
- Show localized user-facing messages via `failure.localizedMessage(l10n)` or `AppDialog`.

### 6. Logging & Security
- Declare `const _log = AppLogger('<Scope>');` at the top of the file.
- **NEVER** use `print()` or `debugPrint()`.
- Never log raw sensitive values; always wrap in `Redacted.secret`, `Redacted.phone`, `Redacted.type`, etc.

### 7. Commits & Code Hygiene
- Never include co-author metadata (`Co-authored-by: ...`).
- Keep code clean with no unused imports. Always verify with `flutter analyze` and `flutter test`.
