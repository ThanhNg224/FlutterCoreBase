# ARCHITECTURE.md

## Purpose

This document defines the architectural principles for this Flutter starter project using **Feature-First Clean Architecture**, **Riverpod Generator (`@riverpod`)**, and **Freezed**.

---

## High-Level Architecture

The project is divided into 3 main functional layers per feature, supported by a shared `core/` infrastructure:

```
      Presentation Layer (UI Screens, Widgets, Riverpod Controllers)
                             │
                             ▼ (depends on)
         Domain Layer (Entities, Value Objects, Repository Interfaces)
                             ▲
                             │ (implements)
          Data Layer (Repositories Impl, Data Sources, DTOs, Mappers)
```

All features can depend on `core/`, but features should remain decoupled from one another.

---

## Layer Responsibilities

### 1. Presentation Layer (`features/<feature>/presentation/`)
- **Responsibilities:**
  - Render declarative Flutter UI widgets.
  - Listen to Riverpod providers (`ref.watch()`, `ref.listen()`).
  - Dispatch user intents to Riverpod Notifier / AsyncNotifier controllers.
  - Handle navigation via GoRouter.
- **Must NOT:**
  - Directly invoke HTTP clients, database, or MethodChannels.
  - Contain domain validation or business calculation rules.

### 2. Domain Layer (`features/<feature>/domain/`)
- **Responsibilities:**
  - Pure Dart business logic and enterprise rules.
  - Immutable domain entities defined with `@freezed`.
  - Repository interfaces (`abstract class IFeatureRepository`).
- **Must NOT:**
  - Depend on Flutter UI (`flutter/material.dart`), SDK platform code, or third-party storage libraries.
  - Depend on the `data/` or `presentation/` layers.

### 3. Data Layer (`features/<feature>/data/`)
- **Responsibilities:**
  - Implement repository interfaces defined in `domain/`.
  - Interact with Remote APIs (`DioClient`), Local Storage (`SharedPreferences`), or Native Platform Channels (`MethodChannel`).
  - Convert DTOs to Domain Entities using mappers.
  - Wrap external exceptions into `Failure` types using `fpdart` (`Either<Failure, T>`).
- **Must NOT:**
  - Expose API-specific structures (raw JSON, HTTP status codes) directly to UI.

---

## State Management with Riverpod Generator

We use `riverpod_annotation` (`@riverpod`) with code generation (`build_runner`):

1. **Controller Pattern:**
   ```dart
   @riverpod
   class FeatureController extends _$FeatureController {
     @override
     FeatureState build() {
       return const FeatureState();
     }

     void updateValue(String value) {
       state = state.copyWith(value: value);
     }
   }
   ```

2. **Async Controller Pattern:**
   ```dart
   @riverpod
   class AsyncFeatureController extends _$AsyncFeatureController {
     @override
     FutureOr<FeatureResult?> build() async {
       return null;
     }

     Future<void> submitAction() async {
       state = const AsyncValue.loading();
       final repo = ref.read(featureRepositoryProvider);
       final result = await repo.execute();
       state = result.fold(
         (failure) => AsyncValue.error(failure.message, StackTrace.current),
         (data) => AsyncValue.data(data),
       );
     }
   }
   ```

3. **KeepAlive vs AutoDispose:**
   - Use `@Riverpod(keepAlive: true)` for singleton services (Router, Theme, Storage, `AppConfigController`).
   - Use default `@riverpod` (autoDispose) for screen-level controllers to prevent memory leaks.
   - Cross-cutting runtime config (`AppConfig`/`AppConfigController`) lives in `core/config/`, not inside a feature's presentation layer.

4. **Passing results across screens:**
   - Pass resolved values explicitly via the route (`context.push(path, extra: value)`) and read from `GoRouterState.extra` in the destination route builder.

---

## Dependency Matrix

| Layer / Module   | Presentation | Domain            | Data | Core              |
| ---------------- | :----------: | :---------------: | :--: | :---------------: |
| **Presentation** |      -       |        Yes        |  No  |        Yes        |
| **Domain**       |      No      |         -         |  No  | Yes (types only)  |
| **Data**         |      No      |  Yes (implements) |  -   |        Yes        |
| **Core**         |      No      |        No         |  No  |         -         |
