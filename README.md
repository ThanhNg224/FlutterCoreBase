# FlutterCoreBase

A Flutter application starter using Feature-First Clean Architecture, Riverpod Generator, and Freezed.

## Prerequisites

Use Flutter >=3.47.0 (Dart >=3.13.0), Python 3.12+, JDK 21, and Android SDK API 37 for Android builds. iOS builds also need the native Apple toolchain.

## Initialize

Clone into your new project directory, then preview and initialize:

```bash
python3 scripts/init_project.py --app-name "Acme Shop" --dart-name acme_shop --bundle-id com.acme.shop --clean-samples --dry-run
python3 scripts/init_project.py --app-name "Acme Shop" --dart-name acme_shop --bundle-id com.acme.shop --clean-samples
```

The interactive wizard and `make init-cli` remain available. The script rebrands supported platforms; omitting `--clean-samples` keeps posts/catalog examples. `--skip-build-check` skips analyze/tests, while dependency resolution and codegen still run. `--no-gitflow` opts out of the existing derived-project Gitflow setup.

## Prepare

Run `make setup` for dependencies, localization, and codegen. It also installs the existing pre-push cache-clean hook; this behavior is documented in [Git workflow](docs/GIT_FLOW.md). Use `make codegen` when hook installation is not desired. `make help` lists the available commands.

Branding, crash-reporting integration, and the reusable component inventory are in [Core modules](docs/CORE_MODULES.md). Release signing requirements are in [Standards](docs/STANDARD.md#android-release-signing).

## Verify

Use [Verification](docs/VERIFICATION.md) for the risk-based local gate, Python initializer tests, archive smoke, and optional clone build. Native CI Android/iOS/Web jobs are separate from analysis and unit tests.

## Run

```bash
make run-dev
# Or the production environment:
make run-prod
```

Add features using [the feature guide](docs/FEATURE_TEMPLATE.md).

## Further reading

- [Agent workflow](AGENTS.md) and [Git workflow](docs/GIT_FLOW.md)
- [Architecture](docs/ARCHITECTURE.md), [Standards](docs/STANDARD.md), [Core modules](docs/CORE_MODULES.md)
