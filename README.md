# Flutter Core Base (Riverpod + Feature-First Clean Architecture)

A production-grade, highly scalable Flutter starter base designed for modern cross-platform development and SDK Host / Demo applications.

---

## 🌟 Architecture Highlights

* **Feature-First Clean Architecture (4 Layers):**
  - `presentation`: UI Widgets, Screens, and Riverpod `AsyncNotifier` / `Notifier` Controllers.
  - `domain`: Pure Dart Entities, Value Objects, and Repository Interfaces (Zero framework dependencies).
  - `data`: Repository Implementations, Remote/Local Data Sources, DTOs, and Mappers.
  - `core`: Shared design system, networking, storage, error handling, and routing.
* **State Management & DI:** **`flutter_riverpod` + `riverpod_generator` (`@riverpod`)**
  - Compile-time safe dependencies.
  - Zero memory leaks via `autoDispose` lifecycle management.
  - Fine-grained widget rebuilds via `.select()` for 60/120 FPS performance.
* **Declarative Routing:** **`go_router`** with deep linking, modal dialogs, and route parameters.
* **Immutability & Modeling:** **`freezed`** + **`json_serializable`** for immutable domain models and state transitions.
* **Functional Error Handling:** **`fpdart` (`Either<Failure, Success>`)** for predictable, non-throwing business workflows.
* **HTTP Client:** **`dio`** with interceptors, timeouts, and automated error mapping.
* **Build Toolchain:** **Java 21 LTS**, **Gradle 8.14**, **Android Gradle Plugin 8.11.1**, **Kotlin 2.2.20**, **Flutter 3.47+**.

---

## 📁 Project Structure

```text
lib/
├── app/
│   ├── app.dart                        # MaterialApp.router (Theme + Router setup)
│   └── observers/
│       └── app_provider_observer.dart  # Global state logging & telemetry
│
├── core/                               # Core Infrastructure (Reusable)
│   ├── constants/                      # AppConstants, StorageKeys
│   ├── errors/                         # Failure, AppException, ErrorHandler
│   ├── network/                        # DioClient, LoggingInterceptor
│   ├── routing/                        # AppRouter, RoutePaths
│   ├── storage/                        # LocalStorageService (SharedPreferences)
│   ├── theme/                          # AppColors, AppTheme, AppTypography, AppSpacing
│   └── widgets/                        # AsyncValueWidget, AppButton, AppCard, AppDialog
│
└── features/                           # Feature Modules (Feature-First)
    ├── catalog/                        # 🎯 Feature 1: SDK Capability Gallery (Home)
    │   ├── data/                       # CatalogRepository
    │   ├── domain/                     # SdkFeature entity
    │   └── presentation/               # CatalogScreen, CatalogController, FeatureCard
    │
    ├── face_otp/                       # 🎯 Feature 2: Face OTP / Biometrics Demo
    │   ├── data/
    │   │   ├── datasources/            # FaceOtpSdkDataSource (SDK / Native Channel wrapper)
    │   │   ├── models/                 # FaceOtpResultDto
    │   │   └── repositories/           # FaceOtpRepositoryImpl
    │   ├── domain/
    │   │   ├── entities/               # FaceOtpConfig, FaceOtpResult
    │   │   └── repositories/           # IFaceOtpRepository (Interface)
    │   └── presentation/
    │       ├── controllers/            # FaceOtpController (AsyncNotifier)
    │       ├── state/                  # FaceOtpState (Freezed union states)
    │       └── views/                  # FaceOtpScreen, VerificationResultCard
    │
    └── settings/                       # 🎯 Feature 3: Environment & Theme
        ├── domain/                     # AppSettings (Environment, Mock mode)
        └── presentation/               # SettingsScreen, SettingsController
```

---

## 🚀 Getting Started

### 1. Prerequisites
- **Flutter SDK:** `>= 3.47.0` (Dart `>= 3.13.0`)
- **JDK:** OpenJDK 21 LTS

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code (`.g.dart`, `.freezed.dart`)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run Code Analysis & Unit Tests
```bash
flutter analyze
flutter test
```

### 5. Build & Run Application
```bash
flutter run
```

---

## 🧩 How to Add a New SDK Feature

To add a new SDK feature (e.g. `id_card_ocr`), follow the 4-layer structure:

1. **Domain Layer (`features/id_card_ocr/domain/`):**
   - Define entity models (e.g. `IdCardResult.dart`).
   - Define repository interface (e.g. `IIdCardRepository.dart`).
2. **Data Layer (`features/id_card_ocr/data/`):**
   - Implement `IdCardSdkDataSource.dart` wrapping native `MethodChannel` or Flutter SDK plugin.
   - Implement `IdCardRepositoryImpl.dart` with `ErrorHandler.guard()`.
3. **Presentation Layer (`features/id_card_ocr/presentation/`):**
   - Create `IdCardState.dart` using `@freezed`.
   - Create `IdCardController.dart` using `@riverpod`.
   - Create `IdCardScreen.dart` consuming state with `ref.watch(idCardControllerProvider)`.
4. **Register in Routing & Catalog:**
   - Add route in `lib/core/routing/app_router.dart`.
   - Add entry in `lib/features/catalog/data/catalog_repository.dart`.
