# Flutter Core Base (Riverpod + Feature-First Clean Architecture)

A production-grade, highly scalable Flutter starter base designed for modern cross-platform development, enterprise host apps, and SDK integration showcases.

---

## 🌟 Architecture Highlights

* **Feature-First Clean Architecture (3 Layers per Feature + Shared Core):**
  - `presentation`: Declarative UI Widgets, Views, and Riverpod `AsyncNotifier` / `Notifier` Controllers.
  - `domain`: Pure Dart Entities, Value Objects, and Repository Interfaces (Zero framework dependencies).
  - `data`: Repository Implementations, Remote APIs, Local Persistence, Native Platform Channels, DTOs, and Mappers.
  - `core`: Shared infrastructure, secure logging, multi-language localization, design system tokens, networking, storage, error handling, and routing.
* **State Management & DI:** **`flutter_riverpod` + `riverpod_generator` (`@riverpod`)**
  - Compile-time safe dependencies.
  - Zero memory leaks via `autoDispose` lifecycle management.
  - Fine-grained widget rebuilds via `.select()`.
* **Enterprise Structured Logging:**
  - Zero release log leakage via `LogPolicy` and `SilentSink`.
  - Type-safe compile-time redaction with `Redacted` wrapper.
  - Global uncaught async error capture via `PlatformDispatcher.instance.onError`.
* **Internationalization & Localization (i18n):**
  - Standard `l10n.yaml` with `flutter_localizations` (English & Vietnamese ARBs included).
  - `LocaleNotifier` for dynamic runtime language switching.
  - `FailureL10n` for mapping domain exceptions into user-friendly localized copy.
* **Accessible Design System & Theming:**
  - Material 3 theme engine with WCAG contrast compliance ($\ge 4.5:1$ text, $\ge 3:1$ non-text).
  - `AppSemanticColors` ThemeExtension accessed via `context.colors`.
  - Reduced-motion animation support via `AppMotion`.
  - Reusable components: `AppButton`, `AppCard`, `AppDialog`, `AppErrorWidget`, `AppSectionHeader`, `AppTextField`.
* **Declarative Routing:** **`go_router`** with deep linking, modal dialogs, and route parameters.
* **Functional Error Handling:** **`fpdart` (`Either<Failure, Success>`)** with `ErrorHandler.guard()`.
* **Build Toolchain:** **Java 21 LTS**, **Gradle 8.14**, **Android Gradle Plugin 8.11.1**, **Kotlin 2.2.20**, **Flutter 3.47+**, 64-bit ABI targets (`arm64-v8a`, `x86_64`), release minification & resource shrinking with Proguard.

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
│   ├── constants/                      # ApiEndpoints, AppConstants, StorageKeys
│   ├── errors/                         # Failure, AppException, ErrorHandler, FailureL10n
│   ├── localization/                   # LocaleNotifier
│   ├── logging/                        # AppLogger, LogLevel, LogPolicy, LogRecord, LogSink, Redacted
│   ├── network/                        # DioClient, LoggingInterceptor
│   ├── routing/                        # AppRouter, RoutePaths
│   ├── storage/                        # LocalStorageService (SharedPreferences)
│   ├── theme/                          # AppColors, AppTheme, AppTypography, AppSpacing, AppSemanticColors, AppMotion
│   ├── utils/                          # Redaction (string masking & formatting helpers)
│   └── widgets/                        # AppButton, AppCard, AppDialog, AppErrorWidget, AppSectionHeader, AppTextField, AsyncValueWidget
│
├── l10n/                               # Localization ARB Dictionaries
│   ├── app_en.arb                      # English dictionary
│   └── app_vi.arb                      # Vietnamese dictionary
│
└── features/                           # Feature Modules (Feature-First Clean Architecture)
    ├── catalog/                        # SDK Feature Catalog & Showcase Gallery
    │   ├── data/                       # CatalogRepository
    │   ├── domain/                     # SdkFeature entity
    │   └── presentation/               # CatalogScreen, CatalogController, FeatureCard
    │
    ├── face_otp/                       # Face OTP / Biometrics Showcase Module
    │   ├── data/                       # FaceOtpSdkDataSource, FaceOtpRepositoryImpl
    │   ├── domain/                     # FaceOtpConfig, FaceOtpResult, IFaceOtpRepository
    │   └── presentation/               # FaceOtpController, FaceOtpState, FaceOtpScreen
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

### 1. Prerequisites
- **Flutter SDK:** `>= 3.47.0` (Dart `>= 3.13.0`)
- **JDK:** OpenJDK 21 LTS

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code & Localization
```bash
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run Code Analysis & Unit Tests
```bash
flutter analyze
flutter test
```

### 5. Run Application
```bash
# Run Development flavor
flutter run --flavor dev

# Run Production flavor
flutter run --flavor prod
```

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
