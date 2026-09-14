# Flutter Core Base

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod_Generator-blue?logo=flutter)](https://riverpod.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First_Clean-green)](#-architecture-pillars)
[![Tests](https://img.shields.io/badge/Tests-83_Passed-success)](#-testing--quality-assurance)

A production-grade, highly maintainable Flutter starter base engineered with **Feature-First Clean Architecture**, **Riverpod Generator**, and enterprise-grade resilience, security, and accessibility standards.

---

## 🌟 Architecture Pillars & Engineering Highlights

* **Feature-First Clean Architecture:**
  - 3-layer boundary per feature (`presentation` $\to$ `domain` $\leftarrow$ `data`) + shared `core/` infrastructure.
  - Zero framework dependencies in domain (`@freezed` entities & abstract repositories).
* **Compile-Time State & DI (`flutter_riverpod` + `riverpod_generator`):**
  - Type-safe, declarative dependencies via `@riverpod` annotations.
  - Zero memory leaks via automatic `autoDispose` controller lifecycles.
  - Granular widget rebuilds using `.select()`.
* **Security by Construction:**
  - **Zero log leakage in release:** All logging routes to `SilentSink` via `LogPolicy` without runtime overhead.
  - **Compile-time redaction:** Logger data parameter strictly requires `Map<String, Redacted>`.
  - **Decoupled credential storage:** Non-sensitive settings in `SharedPreferences`, auth credentials strictly encrypted in `flutter_secure_storage`.
  - **Self-defending network layer:** `AuthInterceptor` auto-clears credential overrides on `401 Unauthorized`.
* **Functional Error Handling (`fpdart`):**
  - Repositories return `Either<Failure, T>` wrapped via `ErrorHandler.guard()`.
  - Zero raw exceptions or stack traces exposed to users; `FailureL10n` maps domain failures directly to localized ARB copy.
  - `AsyncValueWidget<T>` unifies loading, localized error, and data states across the app.
* **Accessible Design System (WCAG 2.1 AA):**
  - Material 3 theme engine with automated tests verifying WCAG contrast ($\ge 4.5:1$ text, $\ge 3:1$ non-text).
  - System reduced-motion compliance via `AppMotion` respecting user accessibility settings.
  - Typography powered by **Inter** (`GoogleFonts.inter`) with full Vietnamese diacritics support.
  - Dynamic `ThemeModeNotifier` (Light / Dark / System) with semantic tokens via `AppSemanticColors` (`context.colors`).
* **Offline-First Resiliency & Runtime Sandbox:**
  - Real-time `OfflineBanner` automatically managed at the root router level via `connectivity_plus`.
  - Modern skeleton loading via `AppShimmer` and `AppShimmerList`.
  - Hot-switch between Dev/Prod environments and Mock SDK mode on-the-fly at runtime without app restarts.
* **Modern Build Toolchain:**
  - **Java 21 LTS**, **Gradle 8.14**, **AGP 8.11.1**, **Kotlin 2.2.20**, 64-bit ABI targets (`arm64-v8a`, `x86_64`), and release R8/Proguard shrinking.

---

## 🛠 Tech Stack Matrix

| Layer / Concern | Technology | Purpose |
| --------------- | ---------- | ------- |
| **Framework & Language** | Flutter 3.47+ · Dart 3.13+ | Cross-platform client SDK |
| **State Management & DI** | `flutter_riverpod` · `riverpod_generator` | Reactive state & compile-time dependency injection |
| **Declarative Routing** | `go_router` | Route matching, deep linking, parameter resolution |
| **Networking & Connectivity** | `dio` · `connectivity_plus` | HTTP client, security interceptors, connection listener |
| **Functional & Immutability** | `fpdart` · `freezed` · `json_serializable` | Functional `Either<Failure, T>`, immutable entities & DTOs |
| **Persistence & Encryption** | `shared_preferences` · `flutter_secure_storage` | Typed local preferences & Keystore/Keychain encryption |
| **Design & Accessibility** | Material 3 · `google_fonts` (Inter) · `flutter_animate` | WCAG tokens, responsive layout, motion-safe transitions |
| **Build & Toolchain** | Java 21 · Gradle 8.14 · AGP 8.11.1 · Kotlin 2.2.20 | 64-bit ABI, R8 Proguard minification & resource shrinking |

---

## 📁 Project Structure

```text
lib/
├── app/
│   ├── app.dart                        # MaterialApp.router (Theme, Locale, Router setup)
│   └── observers/
│       └── app_provider_observer.dart  # Riverpod lifecycle logging & telemetry
│
├── core/                               # Core Infrastructure (Reusable across any app)
│   ├── config/                         # AppConfig, AppConfigController (Dev/Prod, Tokens, Mock)
│   ├── constants/                      # ApiEndpoints, AppConstants, StorageKeys, AppAssets
│   ├── errors/                         # Failure, AppException, ErrorHandler, FailureL10n
│   ├── extensions/                     # BuildContext extensions (context.l10n)
│   ├── localization/                   # LocaleNotifier
│   ├── logging/                        # AppLogger, LogLevel, LogPolicy, LogRecord, LogSink, Redacted
│   ├── network/                        # DioClient, AuthInterceptor, LoggingInterceptor, ConnectivityProvider
│   ├── routing/                        # AppRouter, RoutePaths
│   ├── storage/                        # LocalStorageService (SharedPreferences), SecureStorageService (credentials)
│   ├── theme/                          # AppColors, AppTheme, AppTypography, AppSpacing, AppSemanticColors, AppMotion, ThemeModeNotifier
│   ├── utils/                          # FormValidators, Redaction
│   └── widgets/                        # AppButton, AppBottomSheet, AppCard, AppDialog, AppErrorWidget, AppSectionHeader, AppShimmer, AppSnackbar, AppTextField, AsyncValueWidget, OfflineBanner
│
├── l10n/                               # Localization ARB Dictionaries
│   ├── app_en.arb                      # English dictionary
│   └── app_vi.arb                      # Vietnamese dictionary
│
└── features/                           # Feature Modules (Feature-First Clean Architecture)
    ├── catalog/                        # SDK Feature Catalog & Showcase Gallery
    │   ├── data/                       # CatalogRepository in repositories/ (implements ICatalogRepository)
    │   ├── domain/                     # CatalogFeature entity, ICatalogRepository
    │   └── presentation/               # CatalogScreen, CatalogController, FeatureCard
    │
    ├── posts/                          # Posts & Feed Showcase (REST API, Riverpod, CRUD)
    │   ├── data/                       # PostsRemoteDataSource, PostDto, PostsRepositoryImpl
    │   ├── domain/                     # Post entity, IPostsRepository
    │   └── presentation/               # PostsController, PostDetailController, PostsScreen, PostDetailScreen
    │
    └── settings/                       # Environment, Theme & Credentials Settings
        └── presentation/               # SettingsScreen (Modular cards)
```

---

## 📚 Engineering Documentation

The repository follows strict architectural and coding standards detailed in `docs/`:

| Document | Description |
| -------- | ----------- |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Feature-First Clean Architecture, Riverpod Generator patterns, layer rules, and dependency matrix. |
| [CORE_MODULES.md](docs/CORE_MODULES.md) | In-depth guide to all core infrastructure modules (logging, localization, theme, config, storage). |
| [STANDARD.md](docs/STANDARD.md) | Dart & Flutter coding conventions, formatting, naming rules, and code quality checklist. |
| [FEATURE_TEMPLATE.md](docs/FEATURE_TEMPLATE.md) | Step-by-step guide for creating new feature modules. |
| [GIT_FLOW.md](docs/GIT_FLOW.md) | Branching strategy, Conventional Commits, and collaboration rules. |
| [AGENTS.md](docs/AGENTS.md) | AI assistant engineering workflow and source of truth guidelines. |

---

## 🚀 Getting Started

### 0. Quick Start & Project Initialization

When cloning this repository to bootstrap a new project, use the automated setup wizard to rebrand packages, bundle identifiers, and platform configurations across Dart, Android, iOS, macOS, Web, and Windows:

```bash
# Interactive setup wizard
python3 scripts/init_project.py

# Or automated via CLI flags:
python3 scripts/init_project.py \
  --app-name "Acme Shop" \
  --dart-name "acme_shop" \
  --bundle-id "com.acme.shop" \
  --clean-samples
```

| Flag | Description |
| :--- | :--- |
| `--app-name` | User-facing application display name (e.g., `"Acme Shop"`). |
| `--dart-name` | Dart package name in `snake_case` (e.g., `acme_shop`). |
| `--bundle-id` | Application ID & Bundle Identifier (e.g., `com.acme.shop`). |
| `--clean-samples` | Strips demo features (`posts`, `catalog`) and configures a clean starter `HomeScreen`. |
| `--dry-run` | Previews all modifications without altering files. |
| `--force` | Bypasses git uncommitted working tree check. |
| `--skip-build-check` | Skips post-init `flutter analyze` and `flutter test`. |

For the common development commands, use the root `Makefile`:

```bash
make help
make setup                 # dependencies, localization, and code generation
make format               # apply the canonical Dart formatting
make verify                # format check, analyze, and tests
make ci                   # codegen, format check, analyze, and coverage
make run-dev               # run the dev flavor
make build-apk-dev         # build the dev debug APK
```

The headless initializer is also available through Make:

```bash
make init-cli \
  APP_NAME="Acme Shop" \
  DART_NAME=acme_shop \
  BUNDLE_ID=com.acme.shop \
  CLEAN_SAMPLES=1
```

The Makefile is a convenience wrapper around the Flutter and Python commands. The direct commands below remain the fallback for environments without `make`.

### 1. Prerequisites
- **Flutter SDK:** `>= 3.47.0` (Dart `>= 3.13.0`)
- **JDK:** OpenJDK 21 LTS
- **Android SDK:** API 37 or newer for Android builds

### 2. Install Dependencies
```bash
make pub-get
```

### 3. Generate Code, Localization & Branding Assets
```bash
# Generate localization and code bindings
make codegen

# (Optional) Generate app launcher icons and native splash screens
make branding
```

### 4. Run Code Analysis & Unit Tests
The codebase includes an extensive automated test suite (**83 passing tests**) covering error mapping, security redaction, WCAG contrast verification, reduced-motion compliance, controller lifecycles, and loopback HTTP network integration.

```bash
# Static analysis (Enforces 0 warnings / 0 errors)
make analyze

# Run complete test suite with coverage
make test-coverage
```

### 5. Run Application
```bash
# Run Development flavor
make run-dev

# Run Production flavor
make run-prod
```

### Android release signing

Local release builds fall back to the Android debug key when `android/key.properties` is absent. Before distributing a release, create that file with the production keystore values (`storeFile`, `storePassword`, `keyAlias`, and `keyPassword`); do not commit it to source control.

---

## 🧩 How to Add a New Feature Module

To add a new feature (e.g. `document_scanner`), follow the 3-layer structure in [docs/FEATURE_TEMPLATE.md](docs/FEATURE_TEMPLATE.md):

1. **Domain Layer (`features/<feature>/domain/`):**
   - Create `@freezed` entities and abstract repository interface.
2. **Data Layer (`features/<feature>/data/`):**
   - Implement data sources, repository with `ErrorHandler.guard()`, and expose provider with `@riverpod`.
3. **Presentation Layer (`features/<feature>/presentation/`):**
   - Create `@riverpod` controller and build UI using `AppTheme`, `AppColors`, and `AppSpacing`.
4. **Routing & Registration:**
   - Register route in `lib/core/routing/route_paths.dart` and `lib/core/routing/app_router.dart`.
