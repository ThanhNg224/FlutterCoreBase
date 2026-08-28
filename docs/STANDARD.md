# STANDARD.md

## Purpose

This document defines Dart & Flutter coding standards, formatting guidelines, naming conventions, and best practices for the project. Every developer and AI assistant must follow these rules strictly.

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
- Always use `@freezed` for domain entities, DTOs, and complex UI states.
- Prefer `final` fields and `const` constructors wherever possible.

### 2. Widget Construction & Performance
- Break large widgets into smaller, private or dedicated widget classes.
- Use `const` widgets to optimize Flutter element rebuild trees.
- Use `ref.watch(provider.select((s) => s.specificField))` to avoid rebuilding entire screens on minor state changes.
- Never place asynchronous side effects directly inside widget `build()` methods.
- Keep UI widgets "dumb": UI renders state and delegates events to Riverpod controllers.

### 3. Design System & Theming (Strict Rules)
- **Typography & Font Family:**
  - The standard app font is **Inter** (`GoogleFonts.inter`), configured in `AppTypography` and `AppTheme`.
  - Always use `AppTypography.<style>` or `Theme.of(context).textTheme.<slot>`.
  - **PROHIBITED:** Hardcoding arbitrary `TextStyle(fontSize: 15, ...)` or inline font families in feature widgets.
- **Colors & Semantics:**
  - Always use `context.colors.<token>` (`AppSemanticColors`) for dynamic surfaces, borders, hints, secondary text, and status colors (`statusSuccess`, `statusWarning`, `statusError`, `brandAccent`, `track`).
  - For brand accents, use `Theme.of(context).colorScheme` or `AppColors.primary`.
  - **PROHIBITED:** Hardcoding raw colors (`Colors.grey`, `Colors.red`, `Colors.black`, `Colors.white`, `Color(0xFF...)`) in presentation screens/widgets.
- **Spacing & Radius:**
  - Always use `AppSpacing` tokens (`AppSpacing.xs` (4), `AppSpacing.s` (8), `AppSpacing.m` (16), `AppSpacing.l` (24), `AppSpacing.xl` (32), `AppSpacing.xxl` (48)).
  - Always use `AppSpacing.radiusS/M/L/XL/Full` for border radius.
  - Always use `AppSpacing.pagePadding`, `cardPadding`, `dialogPadding`.
  - **PROHIBITED:** Hardcoding arbitrary pixel values (e.g. `EdgeInsets.all(13)` or `BorderRadius.circular(15)`).
- **Reusable Components:**
  - Always check and reuse `lib/core/widgets/` (`AppButton`, `AppBottomSheet`, `AppCard`, `AppDialog`, `AppErrorWidget`, `AppSectionHeader`, `AppShimmer`/`AppShimmerList`, `AppSnackbar`, `AppTextField`, `AsyncValueWidget`, `OfflineBanner`) before creating custom one-off UI widgets. See `docs/CORE_MODULES.md` for the current, authoritative list.

### 4. Localization & Forms (Strict Rules)
- **Localization:**
  - Always use `context.l10n` (`core/extensions/context_extensions.dart`) to read strings.
  - **PROHIBITED:** Calling `AppLocalizations.of(context)` directly, and writing a nullable fallback like `l10n?.xxx ?? 'English text'` — this silently duplicates every string and drifts from `app_en.arb`/`app_vi.arb` whenever the ARB copy changes.
- **Form Validation:**
  - Always use `FormValidators.required(context)`, `.email(context)`, `.minLength(context, n)`, and `.compose([...])` (`core/utils/form_validators.dart`) for `AppTextField.validator`.
  - **PROHIBITED:** Inline validators returning hardcoded English strings (e.g. `(v) => v!.isEmpty ? 'Required' : null`).
- **Feedback:**
  - Always use `AppSnackbar.showSuccess/showError/showInfo` instead of `ScaffoldMessenger.of(context).showSnackBar(...)` directly.
  - Always use `AppBottomSheet.show(...)` instead of calling `showModalBottomSheet` directly.

### 5. Local Storage & Preferences (Strict Rules)
- Always access local persistence via `ILocalStorageService` (injected via `ref.watch(localStorageServiceProvider)`).
- All storage keys must be declared in `StorageKeys` (`core/constants/storage_keys.dart`).
- **PROHIBITED:** Directly calling `SharedPreferences.getInstance()` in feature screens, widgets, or controllers.

### 6. Error Handling & Architecture
- Return `Future<Either<Failure, T>>` from repositories using `fpdart`.
- Use `ErrorHandler.guard()` in data sources/repositories to automatically catch exceptions and map them to typed `Failure` objects.
- Present human-friendly error messages on the UI layer using `failure.localizedMessage(l10n)` or `AppDialog`. Never expose raw stack traces or technical exception messages to users — including inside a custom `AsyncValueWidget` error branch.

### 7. Code Quality & Security Checklist
- **No unused imports:** Keep files clean and organized.
- **No `print()` or `debugPrint()`:** Use `AppLogger` (`core/logging/`), which is silent in release builds by construction. Declare `const _log = AppLogger('<Scope>');` at the top of the file.
- **Never log raw sensitive values:** Logger's `data` parameter takes `Map<String, Redacted>`. Use `Redacted.secret` / `.phone` / `.length` / `.type` / `.count` / `.flag`, and `Redacted.unredacted(v, because: ...)` for non-sensitive values.
- **Code Gen Check:** Always run `dart run build_runner build --delete-conflicting-outputs` after updating `@riverpod` or `@freezed` models.
- **Analysis:** `flutter analyze` must produce **zero warnings or errors**.
- **Tests:** Run `flutter test` and maintain passing tests for core logic and controllers.
