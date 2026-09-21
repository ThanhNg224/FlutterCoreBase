SHELL := /bin/sh

FLUTTER ?= flutter
DART ?= dart
PYTHON ?= python3

APP_NAME ?=
DART_NAME ?=
BUNDLE_ID ?=
CLEAN_SAMPLES ?=
DRY_RUN ?=
FORCE ?=
SKIP_BUILD_CHECK ?=

DART_DEFINE_DEV ?= --dart-define=APP_ENV=dev
DART_DEFINE_PROD ?= --dart-define=APP_ENV=prod
TARGET_PLATFORMS ?= --target-platform=android-arm64,android-x64
ABI ?= android-arm64

INIT_OPTIONS = \
  $(if $(CLEAN_SAMPLES),--clean-samples) \
  $(if $(DRY_RUN),--dry-run) \
  $(if $(FORCE),--force) \
  $(if $(SKIP_BUILD_CHECK),--skip-build-check)

.DEFAULT_GOAL := help

.PHONY: help init init-dry-run init-cli pub-get gen-l10n build-runner codegen setup \
  format format-check analyze test test-coverage verify ci branding run-dev run-prod \
  build-apk-dev build-apk-prod build-appbundle-prod clean deep-clean clean-artifacts

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make <target> [VARIABLE=value]\n\nTargets:\n"} /^[a-zA-Z0-9_-]+:.*##/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Run the interactive project initialization wizard
	$(PYTHON) scripts/init_project.py

init-dry-run: ## Preview the interactive initialization without modifying files
	$(PYTHON) scripts/init_project.py --dry-run

init-cli: ## Initialize headlessly; requires APP_NAME, DART_NAME, and BUNDLE_ID
	@test -n "$(APP_NAME)" || (echo "APP_NAME is required"; exit 2)
	@test -n "$(DART_NAME)" || (echo "DART_NAME is required"; exit 2)
	@test -n "$(BUNDLE_ID)" || (echo "BUNDLE_ID is required"; exit 2)
	$(PYTHON) scripts/init_project.py \
	  --app-name "$(APP_NAME)" \
	  --dart-name "$(DART_NAME)" \
	  --bundle-id "$(BUNDLE_ID)" \
	  $(INIT_OPTIONS)

pub-get: ## Resolve Flutter dependencies
	$(FLUTTER) pub get

gen-l10n: ## Generate localization bindings
	$(FLUTTER) gen-l10n

build-runner: ## Generate Riverpod, Freezed, and JSON bindings
	$(DART) run build_runner build

codegen: pub-get gen-l10n build-runner ## Resolve dependencies and regenerate generated code
	$(DART) format .

setup: codegen ## Prepare a fresh checkout for development

format: ## Format all Dart files
	$(DART) format .

format-check: ## Verify Dart formatting without changing files
	$(DART) format --output=none --set-exit-if-changed .

analyze: ## Run static analysis with infos treated as errors
	$(FLUTTER) analyze --fatal-infos

test: ## Run the complete Flutter test suite
	$(FLUTTER) test

test-coverage: ## Run tests and write coverage/lcov.info
	$(FLUTTER) test --coverage

verify: format-check analyze test ## Run the local pre-commit verification gate

ci: codegen format-check analyze test-coverage ## Run the CI-equivalent local gate

branding: ## Regenerate launcher icons and native splash assets
	$(DART) run flutter_launcher_icons
	$(DART) run flutter_native_splash:create

run-dev: ## Run the development environment
	$(FLUTTER) run $(DART_DEFINE_DEV)

run-prod: ## Run the production environment
	$(FLUTTER) run $(DART_DEFINE_PROD)

build-apk-dev: ## Build the development debug APK (default: android-arm64, override with ABI=android-x64)
	$(FLUTTER) build apk --debug $(DART_DEFINE_DEV) --target-platform=$(ABI)

build-apk-prod: ## Build the production release APK with obfuscation and symbol splitting (64-bit arm64 & x86_64 only)
	$(FLUTTER) build apk --release $(DART_DEFINE_PROD) $(TARGET_PLATFORMS) --obfuscate --split-debug-info=build/app/outputs/symbols

build-appbundle-prod: ## Build the production release App Bundle (AAB) with obfuscation and symbol splitting (64-bit arm64 & x86_64 only)
	$(FLUTTER) build appbundle --release $(DART_DEFINE_PROD) $(TARGET_PLATFORMS) --obfuscate --split-debug-info=build/app/outputs/symbols

clean-artifacts: ## Remove build outputs and test cache without clearing Gradle compilation cache
	rm -rf build/app/outputs build/test_cache build/*.cache.dill

clean: ## Clean build cache and temporary files
	$(FLUTTER) clean
	$(FLUTTER) pub get

deep-clean: ## Deep clean including Flutter and native Android build caches
	$(FLUTTER) clean
	cd android && ./gradlew clean
	$(FLUTTER) pub get

