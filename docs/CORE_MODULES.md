# CORE_MODULES.md

## Overview

The `lib/core/` directory contains shared, application-wide infrastructure that all feature modules rely on.

```text
lib/core/
├── config/              # AppConfig, AppConfigController — cross-cutting runtime config
├── constants/           # Global endpoints, constants, storage keys
├── errors/              # AppException, Failure, ErrorHandler, FailureL10n
├── extensions/          # BuildContext extensions (context.l10n)
├── localization/        # LocaleNotifier, multi-language switching
├── logging/             # AppLogger, LogLevel, LogPolicy, LogRecord, LogSink, Redacted
├── network/             # DioClient, AuthInterceptor, LoggingInterceptor, ConnectivityProvider (isOnlineProvider)
├── routing/             # GoRouter configuration & RoutePaths
├── storage/             # LocalStorageService (SharedPreferences) & SecureStorageService (credentials)
├── theme/               # AppColors, AppTheme, AppTypography, AppSpacing, AppSemanticColors, AppMotion
├── utils/               # FormValidators, Redaction — pure helpers shared by UI and logger
└── widgets/             # Reusable UI components — see "Reusable UI Widgets" below for the current list
```

> This file is the single source of truth for what exists in `core/`. `CLAUDE.md`, `AGENTS.md`, `docs/STANDARD.md`, `README.md`, and `.github/copilot-instructions.md` all point back here instead of duplicating the full widget/util list — update it first when adding a new shared component.

---

## 1. Design System & Theme (`core/theme/`)

- **`AppColors`**: Brand palette, semantic status colors, and contrast-tested foreground colors (WCAG >= 4.5:1).
- **`AppTheme`**: Builds Material 3 `ThemeData` for light/dark via `ColorScheme.fromSeed(seedColor: AppColors.primary)`, explicit `textTheme` mapping from `AppTypography`, `fontFamily: AppTypography.fontFamily`, button themes, `inputDecorationTheme`, `segmentedButtonTheme`, and `dividerTheme`.
- **`AppTypography`**: Centralized text styles matching the design hierarchy, powered by **Inter** (`GoogleFonts.inter`) for clean legibility and full Vietnamese diacritics support.
- **`AppSemanticColors`**: A `ThemeExtension` for raw `Color` values (icons, borders, surfaces, status tokens) accessed via `context.colors`.
- **`AppMotion`**: Accessible animation tokens and `.staggeredEntrance()` respecting reduced-motion accessibility settings.
- **`AppSpacing`**: Standardized 8-point grid paddings, margins, and border radius tokens.

---

## 2. Config (`core/config/`)

- **`AppConfig`**: Immutable cross-cutting runtime config (environment, base URL, credentials, mock SDK mode, version).
- **`AppConfigController`**: `@Riverpod(keepAlive: true)` single source of truth for `AppConfig`, persisted via `LocalStorageService`.

---

## 3. Localization (`core/localization/` & `l10n/`)

- **`app_en.arb` & `app_vi.arb`**: Multi-language translation dictionaries.
- **`LocaleNotifier`**: Riverpod provider for active app `Locale` with SharedPreferences persistence.
- **`FailureL10n`**: Extension converting domain `Failure` instances into human-friendly localized copy.

---

## 4. Logging (`core/logging/`)

Enforces two safety guarantees by construction:

**1. Silent in release, by construction.** Every call passes `LogPolicy.allows()`. In release builds, `SilentSink` discards all logs.
**2. Redacted by default.** The `data` parameter is typed `Map<String, Redacted>`, preventing raw sensitive values from compiling.

| Constructor | Use for |
| ----------- | ------- |
| `Redacted.secret(v)` | Tokens, client keys, secret IDs |
| `Redacted.phone(v)` | Phone numbers / masked identifiers |
| `Redacted.length(v)` | Payloads or byte arrays |
| `Redacted.type(v)` | Entity type name |
| `Redacted.count(n)` / `Redacted.flag(b)` | Cardinality and booleans |
| `Redacted.unredacted(v, because:)` | Verbatim values that carry no sensitive data |

---

## 5. Networking (`core/network/`)

- **`DioClient`**: `@Riverpod(keepAlive: true)` HTTP client with timeouts, rebuilt from `AppConfigController` when the environment changes.
- **`AuthInterceptor`**: Attaches `Authorization`/`X-Client-Key` from `AppConfig` to every request; clears credential overrides on a 401 scoped to the app's own `baseUrl`.
- **`LoggingInterceptor`**: Logs request/response method and endpoints via `AppLogger` without exposing sensitive bodies.
- **`ConnectivityProvider`** (`isOnlineProvider`): `Stream<bool>` from `connectivity_plus`; drives `OfflineBanner`.

---

## 6. Routing (`core/routing/`)

- **`RoutePaths`**: Constants for all route paths.
- **`AppRouter`**: Declarative GoRouter instance provided via Riverpod (`appRouterProvider`).

---

## 7. Storage (`core/storage/` & `core/constants/storage_keys.dart`)
 
- **`ILocalStorageService` & `LocalStorageService`**: Typed abstraction and wrapper around `SharedPreferences` for non-sensitive, type-safe key-value persistence.
- **`ISecureStorageService` & `SecureStorageService`**: `flutter_secure_storage`-backed storage for credential overrides (app token, client key) only. Never put credentials in `ILocalStorageService`.
- **`StorageKeys`**: Centralized repository of all persistent storage keys.
- **`storageProviders`**: Injected via `ProviderScope` override in `main.dart` (`localStorageServiceProvider`).

---

## 8. Utils (`core/utils/`)

- **`FormValidators`**: l10n-aware `FormFieldValidator<String>` factories — `required(context)`, `email(context)`, `minLength(context, n)`, `compose([...])`. Always use these for `AppTextField.validator` instead of writing inline validators with hardcoded English strings.
- **`Redaction`**: Pure masking helpers shared by `AppLogger`'s `Redacted` wrappers and UI previews (e.g. masked credentials in Settings).

---

## 9. Extensions (`core/extensions/`)

- **`ContextExtensions`** (`context.l10n`): Non-null `AppLocalizations` accessor. Always use `context.l10n.xxx` — never `AppLocalizations.of(context)` and never the `l10n?.xxx ?? 'English fallback'` pattern, which silently duplicates every string and drifts from the ARB files.

---

## 10. Reusable UI Widgets (`core/widgets/`)

Always check this table before writing a new one-off widget:

| Widget | Use for |
| ------ | ------- |
| `AppButton` | Primary/secondary/outline/danger buttons with a built-in loading state. |
| `AppCard` | Standard elevated/outlined content container. |
| `AppDialog` | `showResultDialog()` (success/error) and `showActionDialog()` (confirm/cancel) alert dialogs. |
| `AppBottomSheet` | `AppBottomSheet.show(...)` — rounded top corners, drag handle, optional icon/title header with a close action, and keyboard-safe padding. Use this instead of calling `showModalBottomSheet` directly. |
| `AppSnackbar` | `showSuccess()` / `showError()` / `showInfo()`. Use this instead of `ScaffoldMessenger.of(context).showSnackBar(...)` directly. |
| `AppShimmer` / `AppShimmerList` | Skeleton loading placeholders for lists — pass as `AsyncValueWidget`'s `loading:` builder instead of a bare `CircularProgressIndicator` for content lists. |
| `AppErrorWidget` | Installed as `ErrorWidget.builder`; not for direct use in feature code. |
| `AppSectionHeader` | Section title + subtitle heading used inside settings/catalog screens. |
| `AppTextField` | Standard text input with label/hint/validator wiring. |
| `AsyncValueWidget<T>` | Renders `AsyncValue<T>` loading/error/data states consistently; error state already maps `Failure` to `failure.localizedMessage(l10n)` — never render `err.toString()` in a custom error branch. |
| `OfflineBanner` | Auto-shown/hidden via `isOnlineProvider`; wired once in `app.dart`, no per-screen setup needed. |
