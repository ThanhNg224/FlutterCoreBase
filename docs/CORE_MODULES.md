# CORE_MODULES.md

## Overview

The `lib/core/` directory contains shared, application-wide infrastructure that all feature modules rely on.

```text
lib/core/
├── config/              # AppConfig, AppConfigController, AppEnvironment, DevTools — cross-cutting runtime config
├── constants/           # ApiEndpoints, AppConstants, StorageKeys, AppAssets
├── errors/              # AppException, Failure, ErrorHandler, FailureL10n
├── extensions/          # BuildContext extensions (context.l10n)
├── localization/        # LocaleNotifier, multi-language switching
├── logging/             # AppLogger, LogLevel, LogPolicy, LogRecord, LogSink, Redacted, CrashReporter, ErrorReporting
├── network/             # AuthDioClient, AuthInterceptor, LoggingInterceptor, ConnectivityProvider (isOnlineProvider)
├── routing/             # RoutePaths (pure data — AppRouter itself lives at lib/app/routing/)
├── storage/             # LocalStorageService (SharedPreferences) & SecureStorageService (credentials)
├── theme/               # AppColors, AppTheme, AppTypography, AppSpacing, AppSemanticColors, AppMotion, ThemeModeNotifier
├── utils/               # FormValidators, Redaction — pure helpers shared by UI and logger
└── widgets/             # Reusable UI components — see "Reusable UI Widgets" below for the current list
```

> `lib/app/` is the composition root (the only layer allowed to import
> features): `lib/app/routing/app_router.dart` (GoRouter instance + the auth
> redirect guard) and `lib/app/network/app_dio_client.dart` (the app's Dio,
> composed with `AuthInterceptor`) both live there instead of under `core/`.

> This file is the single source of truth for what exists in `core/`. `CLAUDE.md`, `AGENTS.md`, `docs/STANDARD.md`, `README.md`, and `.github/copilot-instructions.md` all point back here instead of duplicating the full widget/util list — update it first when adding a new shared component.

---

## 1. Design System & Theme (`core/theme/`)

- **`AppColors`**: Brand palette, semantic status colors, and contrast-tested foreground colors (WCAG >= 4.5:1).
- **`AppTheme`**: Builds Material 3 `ThemeData` for light/dark via `ColorScheme.fromSeed(seedColor: AppColors.primary)`, explicit `textTheme` mapping from `AppTypography`, `fontFamily: AppTypography.fontFamily`, button themes, `inputDecorationTheme`, `segmentedButtonTheme`, and `dividerTheme`.
- **`AppTypography`**: Centralized text styles matching the design hierarchy, powered by **Inter** (`GoogleFonts.inter`) for clean legibility and full Vietnamese diacritics support.
- **`AppSemanticColors`**: A `ThemeExtension` for raw `Color` values (icons, borders, surfaces, status tokens) accessed via `context.colors`.
- **`AppMotion`**: Accessible animation tokens and `.staggeredEntrance()` respecting reduced-motion accessibility settings.
- **`AppSpacing`**: Standardized 8-point grid paddings, margins, and border radius tokens.
- **`ThemeModeNotifier`**: `@Riverpod(keepAlive: true)` for dynamic app `ThemeMode` (Light, Dark, System) toggle and SharedPreferences persistence.

---

## 2. Config (`core/config/`)

- **`AppConfig`**: Immutable cross-cutting runtime config (environment, base URL, credentials, mock SDK mode, version).
- **`AppConfigController`**: `@Riverpod(keepAlive: true)` single source of truth for `AppConfig`, persisted via `LocalStorageService`. Defaults to the build-time environment (`AppEnvironment.build`); the persisted `StorageKeys.useDevEnvironment` toggle is a debug-only override, and all four runtime mutators are rejected with `Failure.devToolsDisabled()` when `DevTools.isEnabled` is false.
- **`AppEnvironment`**: Pure, `@visibleForTesting`-seamed resolver for which backend environment this binary was *built* for — `--dart-define=APP_ENV` first, then production. No Riverpod, no storage.
- **`DevTools`**: Single predicate (`DevTools.isEnabled`) answering "may this build mutate its own runtime config?". True for any non-release build and for release builds of a non-production environment; false only for a production release build.

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

**Crash reporting (`CrashReporter` & `ErrorReporting`)**

`ErrorReporting.install()` — called once from `main()`, before `runApp` — is the
single place that wires all three global error boundaries: `FlutterError.onError`
(framework build/layout/paint errors), `PlatformDispatcher.instance.onError`
(uncaught async errors) and `ErrorWidget.builder`. Both handlers log through
`AppLogger` and then unconditionally forward to a `CrashReporter`, because
logging is silent-by-design in release while a crash must still be reported —
the reporter call is never gated by `LogPolicy`. The base ships with
`NoopCrashReporter` (does nothing, no vendor dependency); a real project wires
Sentry/Crashlytics/etc. by implementing `CrashReporter` and passing it to
`ErrorReporting.install(reporter: ...)` — no other file needs to change. See
`README.md` for the wiring snippet and `test/core/logging/error_reporting_test.dart`
for the pure, `@visibleForTesting` seams (`handleFlutterError`,
`handlePlatformError`, `setReporterForTest`, `setDebugModeForTest`) used to test
this without touching global handlers.

---

## 5. Networking (`core/network/` & `app/network/`)

- **`AppDioClient`** (`lib/app/network/app_dio_client.dart`, `dioClientProvider`): `@Riverpod(keepAlive: true)` HTTP client with timeouts, rebuilt from `AppConfigController` when the environment changes. Composes `AuthInterceptor` with the auth session, so it lives in `app/` rather than `core/` (wiring auth means reaching into a feature).
- **`AuthDioClient`** (`core/network/auth_dio_client.dart`, `authDioProvider`): a second, interceptor-free Dio used by the auth data source and by `AuthInterceptor`'s own replay, so a refresh/replay call can never recurse back through itself.
- **`AuthInterceptor`**: Attaches the bearer token to every request; on a 401 scoped to the app's own `baseUrl`, single-flight refreshes the session via `AuthController` and replays the original request against `AuthDioClient`.
- **`LoggingInterceptor`**: Logs request/response method and endpoints via `AppLogger` without exposing sensitive bodies.
- **`ConnectivityProvider`** (`isOnlineProvider`): `Stream<bool>` from `connectivity_plus`; drives `OfflineBanner`. This is connectivity awareness only — there is no local cache or request queue.

---

## 6. Routing (`core/routing/` & `app/routing/`)

- **`RoutePaths`** (`core/routing/route_paths.dart`): Constants for all route paths. Pure data, so it stays in `core/`.
- **`AppRouter`** (`lib/app/routing/app_router.dart`, `appRouterProvider`): Declarative GoRouter instance provided via Riverpod, including the `redirect` guard that reads `AuthController` and sends unauthenticated users to `login`/`splash`. Lives under `lib/app/` — the composition root — because it imports feature screens, which `core/` must never do (enforced by `test/architecture/layer_boundaries_test.dart`).

---

## 7. Storage (`core/storage/` & `core/constants/storage_keys.dart`)
 
- **`ILocalStorageService` & `LocalStorageService`**: Typed abstraction and wrapper around `SharedPreferences` for non-sensitive, type-safe key-value persistence. Covers `String`, `bool`, `double`, `int`, and `List<String>` — always add a new type here rather than reaching for `SharedPreferences` directly in a feature.
- **`ISecureStorageService` & `SecureStorageService`**: `flutter_secure_storage`-backed storage for credential overrides (app token, client key) only. Never put credentials in `ILocalStorageService`. The provider (`core/storage/storage_providers.dart`) declares platform options explicitly instead of relying on package defaults: Android uses `AndroidOptions()` (v11+ already wraps stored data in AES/GCM with an RSA-OAEP-wrapped key — there is no `encryptedSharedPreferences` flag to set on this major version), and iOS/macOS use `KeychainAccessibility.first_unlock_this_device` so tokens never sync via iCloud Keychain and stay inaccessible before the device's first unlock.
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

---

## 11. Constants (`core/constants/`)

- **`ApiEndpoints`**: Base URLs (`prodUrl`, `devUrl`), API endpoint paths, and runtime credential defaults loaded via `String.fromEnvironment`.
- **`AppConstants`**: Global application constants (`appName`, `connectTimeout`, `receiveTimeout`, `mockSdkDelay`).
- **`AppAssets`**: Centralized asset paths for launcher and splash branding (`appIcon`, `appIconForeground`, `splashIcon`).
- **`StorageKeys`**: Centralized persistent keys used across `ILocalStorageService` and `ISecureStorageService`.

---

## 12. Error Handling (`core/errors/`)

- **`AppException`**: Base hierarchy for low-level application exceptions (`ServerException`, `NetworkException`, `PlatformException`, `StorageException`, `UnauthorizedException`, `UnexpectedException`).
- **`Failure`**: Domain-level union type defined with `@freezed` for functional error returns (`Either<Failure, T>`).
- **`ErrorHandler`**: Centralized error mapper (`handleException`, `handleDioError`) and async wrapper (`ErrorHandler.guard()`).
- **`FailureL10n`**: Extension mapping each domain `Failure` instance to user-friendly localized copy via `failure.localizedMessage(context.l10n)`.

