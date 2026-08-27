# GitHub Copilot Instructions for FlutterCoreBase

## Architectural Boundaries
- Feature-First Clean Architecture (`lib/features/<feature>/{domain, data, presentation}`).
- Domain layer is pure Dart without Flutter dependencies.
- Data layer implements domain repositories and uses `ErrorHandler.guard()`.
- Presentation layer renders UI and delegates to Riverpod controllers.

## Design System & UI Rules
- Typography: Use **Inter** (`GoogleFonts.inter`), `AppTypography`, and `Theme.of(context).textTheme`.
- Colors: Always use `context.colors.<token>` (`AppSemanticColors`) for dynamic surfaces, borders, text, and status colors. Use `Theme.of(context).colorScheme` or `AppColors.primary` for brand accents. Never hardcode `Colors.grey`, `Colors.red`, `Color(0xFF...)`.
- Spacing: Use `AppSpacing` tokens (`xs`, `s`, `m`, `l`, `xl`, `xxl`) and `AppSpacing.radius*`.
- Reuse: Check `lib/core/widgets/` (`AppButton`, `AppCard`, `AppTextField`, `AppDialog`, `AppErrorWidget`, `AsyncValueWidget`) before creating new widgets.

## State Management & Storage
- Riverpod Generator: `@riverpod` (auto-dispose) for screen controllers, `@Riverpod(keepAlive: true)` for singletons/shared services.
- Storage: Always inject `localStorageServiceProvider` (`ILocalStorageService`). Define keys in `StorageKeys`.

## Error Handling & Logging
- Repositories return `Future<Either<Failure, T>>` (`fpdart`).
- Logging: `const _log = AppLogger('<Scope>');` with `Redacted` wrappers. Never use `print()` or `debugPrint()`.

## Verification
- Code generation: `dart run build_runner build --delete-conflicting-outputs`.
- Analysis: `flutter analyze` must have 0 warnings.
- Never write co-author trailers in commit messages.
