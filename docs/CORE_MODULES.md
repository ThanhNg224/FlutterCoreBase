# CORE_MODULES.md

## Overview

The `lib/core/` directory contains shared, application-wide infrastructure that all feature modules rely on.

```text
lib/core/
├── config/              # AppConfig, AppConfigController — cross-cutting runtime config
├── constants/           # Global endpoints, constants, storage keys
├── errors/              # AppException, Failure, ErrorHandler, FailureL10n
├── localization/        # LocaleNotifier, multi-language switching
├── logging/             # AppLogger, LogLevel, LogPolicy, LogRecord, LogSink, Redacted
├── network/             # DioClient, LoggingInterceptor
├── routing/             # GoRouter configuration & RoutePaths
├── storage/             # LocalStorageService wrapper around SharedPreferences
├── theme/               # AppColors, AppTheme, AppTypography, AppSpacing, AppSemanticColors, AppMotion
├── utils/               # Redaction — pure masking helpers shared by UI and logger
└── widgets/             # Reusable UI components (AppButton, AppCard, AppDialog, AppErrorWidget, AppSectionHeader, AppTextField, AsyncValueWidget)
```

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

- **`DioClient`**: Configured HTTP client with timeouts and error handling.
- **`LoggingInterceptor`**: Logs request/response method and endpoints via `AppLogger` without exposing sensitive bodies.

---

## 6. Routing (`core/routing/`)

- **`RoutePaths`**: Constants for all route paths.
- **`AppRouter`**: Declarative GoRouter instance provided via Riverpod (`appRouterProvider`).

---

## 7. Storage (`core/storage/` & `core/constants/storage_keys.dart`)
 
- **`ILocalStorageService` & `LocalStorageService`**: Typed abstraction and wrapper around `SharedPreferences` for type-safe key-value persistence.
- **`StorageKeys`**: Centralized repository of all persistent storage keys.
- **`storageProviders`**: Injected via `ProviderScope` override in `main.dart` (`localStorageServiceProvider`).
