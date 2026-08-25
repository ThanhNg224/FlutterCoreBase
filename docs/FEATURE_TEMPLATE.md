# FEATURE_TEMPLATE.md

## Feature Module Structure

Every new feature in `lib/features/<feature_name>/` must adhere to the 3-layer architecture:

```text
lib/features/<feature_name>/
├── domain/
│   ├── entities/               # Freezed entity models
│   │   └── <entity>.dart
│   └── repositories/           # Abstract repository interface
│       └── i_<feature>_repository.dart
│
├── data/
│   ├── datasources/            # Remote API / MethodChannel / Local data source
│   │   └── <feature>_datasource.dart
│   ├── models/                 # DTOs & JSON serialization (if applicable)
│   │   └── <dto>.dart
│   └── repositories/           # Concrete repository implementation
│       └── <feature>_repository_impl.dart
│
└── presentation/
    ├── controllers/            # Riverpod @riverpod Notifiers / AsyncNotifiers
    │   └── <feature>_controller.dart
    ├── views/                  # Main Screen Widget
    │   └── <feature>_screen.dart
    └── widgets/                # Feature-specific sub-widgets
        └── <component>_card.dart
```

---

## Step-by-Step Feature Implementation Guide

1. **Step 1: Domain Entities & Repository Interface**
   - Create entity with `@freezed`.
   - Create `i_<feature>_repository.dart` returning `Future<Either<Failure, Entity>>`.

2. **Step 2: Data Source & Repository Implementation**
   - Implement data retrieval in `data/datasources/`.
   - Implement repository in `data/repositories/` using `ErrorHandler.guard()`.
   - Expose repository provider via `@riverpod`.
   - Log with a file-local `const _log = AppLogger('<Feature>');`.

3. **Step 3: Presentation Controller & State**
   - Create Notifier with `@riverpod`.
   - Manage UI loading, error, and data states.

4. **Step 4: Presentation Screen & Widgets**
   - Build UI using `AppTheme`, `AppColors`, and `AppSpacing`.
   - Connect UI to controller via `ref.watch()`.

5. **Step 5: Register Route & Catalog**
   - Add path in `core/routing/route_paths.dart`.
   - Register route in `core/routing/app_router.dart`.
   - Add entry in `features/catalog/data/catalog_repository.dart`.

6. **Step 6: Code Generation & Verification**
   - Run `dart run build_runner build --delete-conflicting-outputs`.
   - Run `flutter analyze` and write unit tests in `test/features/<feature_name>/`.
