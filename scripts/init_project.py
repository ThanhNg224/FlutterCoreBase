#!/usr/bin/env python3
"""
Flutter Project Initialization & Rebranding Script
-------------------------------------------------
Automates rebranding and reconfiguration of FlutterCoreBase starter projects
across all supported platforms (Dart, Android, iOS, macOS, Web, Windows).

Usage:
    python3 scripts/init_project.py [OPTIONS]

Options:
    --app-name TEXT         User-facing application name (e.g., "Acme Shop")
    --dart-name TEXT        Dart package name (snake_case, e.g., "acme_shop")
    --bundle-id TEXT        Application ID / Bundle ID (e.g., "com.acme.shop")
    --clean-samples         Remove sample demo features (posts & catalog)
    --dry-run               Preview changes without modifying any files
    --force                 Bypass git working directory clean check
    --skip-build-check      Skip post-init flutter analyze and flutter test
    -h, --help              Show this help message and exit
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Tuple
from xml.sax.saxutils import escape as escape_xml_text

# Terminal color styling
GREEN = "\033[92m"
YELLOW = "\033[93m"
RED = "\033[91m"
BLUE = "\033[94m"
BOLD = "\033[1m"
RESET = "\033[0m"


def log_info(msg: str) -> None:
    print(f"{BLUE}[INFO]{RESET} {msg}")


def log_success(msg: str) -> None:
    print(f"{GREEN}[SUCCESS]{RESET} {msg}")


def log_warn(msg: str) -> None:
    print(f"{YELLOW}[WARN]{RESET} {msg}")


def log_error(msg: str) -> None:
    print(f"{RED}[ERROR]{RESET} {msg}")


# Reserved keywords in Dart
DART_RESERVED_KEYWORDS = {
    "assert", "break", "case", "catch", "class", "const", "continue", "default",
    "do", "else", "enum", "extends", "false", "final", "finally", "for", "if",
    "in", "is", "new", "null", "rethrow", "return", "super", "switch", "this",
    "throw", "true", "try", "var", "void", "while", "with", "flutter", "flutter_test"
}


def validate_app_name(name: str) -> Tuple[bool, str]:
    """Validate user-facing application name."""
    cleaned = name.strip()
    if not cleaned:
        return False, "App name cannot be empty."
    if len(cleaned) > 50:
        return False, "App name cannot exceed 50 characters."
    if any(c in cleaned for c in ('"', "'", "<", ">", "\n", "\r", "\\", "\0")):
        return False, "App name contains invalid characters."
    return True, ""


def validate_dart_name(name: str) -> Tuple[bool, str]:
    """
    Validate Dart package name.
    Must be lowercase alphanumeric and underscores, beginning with a letter.
    """
    cleaned = name.strip()
    if not cleaned:
        return False, "Dart package name cannot be empty."
    if not re.match(r"^[a-z][a-z0-9_]*$", cleaned):
        return False, "Dart package name must start with a lowercase letter and contain only lowercase letters, digits, and underscores (snake_case)."
    if cleaned in DART_RESERVED_KEYWORDS:
        return False, f"'{cleaned}' is a reserved Dart keyword or SDK identifier."
    return True, ""


def validate_bundle_id(bundle_id: str) -> Tuple[bool, str]:
    """
    Validate Android Application ID and iOS/macOS Bundle Identifier.
    Must be reverse-domain format with at least two segments.
    """
    cleaned = bundle_id.strip()
    if not cleaned:
        return False, "Bundle ID cannot be empty."
    segments = cleaned.split(".")
    if len(segments) < 2:
        return False, "Bundle ID must be in reverse-domain format with at least two segments (e.g., com.example.myapp)."
    for seg in segments:
        if not seg:
            return False, "Bundle ID cannot contain empty segments."
        if not re.match(r"^[a-zA-Z0-9_]+$", seg):
            return False, f"Segment '{seg}' contains invalid characters."
        if seg[0].isdigit():
            return False, f"Segment '{seg}' cannot start with a digit."
    return True, ""


def to_pascal_case(text: str) -> str:
    """Convert a phrase or snake_case string to PascalCase."""
    parts = re.split(r"[^a-zA-Z0-9]+", text)
    return "".join(p.capitalize() for p in parts if p)


def suggest_dart_name(app_name: str) -> str:
    """Derive a recommended Dart package name from an app name."""
    s = re.sub(r"[^a-zA-Z0-9]+", "_", app_name).lower()
    s = re.sub(r"_+", "_", s).strip("_")
    if not s or s[0].isdigit():
        s = f"app_{s}" if s else "my_app"
    if s in DART_RESERVED_KEYWORDS:
        s = f"{s}_app"
    return s


def suggest_bundle_id(app_name: str, domain_prefix: str = "com.example") -> str:
    """Derive a recommended reverse-domain Bundle ID from an app name."""
    app_part = re.sub(r"[^a-zA-Z0-9]", "", app_name).lower()
    if not app_part or app_part[0].isdigit():
        app_part = f"app{app_part}"
    return f"{domain_prefix}.{app_part}"


@dataclass
class ProjectConfig:
    app_name: str
    dart_name: str
    bundle_id: str
    clean_samples: bool = False
    dry_run: bool = False
    force: bool = False
    skip_build_check: bool = False

    @property
    def app_class_name(self) -> str:
        """PascalCase App class name (e.g., AcmeShopApp)."""
        base = to_pascal_case(self.app_name)
        if base and base[0].isdigit():
            base = f"App{base}"
        return f"{base}App"

    @property
    def short_name(self) -> str:
        """Short name for web manifest."""
        return to_pascal_case(self.app_name)


def find_project_root(start_dir: Optional[Path] = None) -> Path:
    """Locate the Flutter project root directory."""
    cur = (start_dir or Path.cwd()).resolve()
    while cur != cur.parent:
        pubspec = cur / "pubspec.yaml"
        main_dart = cur / "lib" / "main.dart"
        if pubspec.is_file() and main_dart.is_file():
            return cur
        cur = cur.parent
    raise FileNotFoundError("Could not find Flutter project root (missing pubspec.yaml or lib/main.dart).")


def check_git_clean(root: Path, force: bool) -> bool:
    """Check if git working tree has uncommitted modifications."""
    if not (root / ".git").exists():
        return True
    try:
        res = subprocess.run(
            ["git", "status", "--porcelain", "-uno"],
            cwd=root,
            capture_output=True,
            text=True,
            check=True,
        )
        if res.stdout.strip() and not force:
            log_warn("Git repository has uncommitted tracked changes:")
            for line in res.stdout.strip().splitlines()[:5]:
                print(f"  {line}")
            log_warn("Commit or stash changes before running, or pass --force to bypass.")
            return False
    except (subprocess.SubprocessError, FileNotFoundError):
        pass
    return True


def replace_in_file(file_path: Path, pattern: str, replacement: str, dry_run: bool) -> int:
    """Replace occurrences of pattern with replacement in a text file."""
    if not file_path.is_file():
        return 0
    try:
        content = file_path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return 0

    new_content, count = re.subn(pattern, replacement, content)
    if count > 0 and not dry_run:
        file_path.write_text(new_content, encoding="utf-8")
    return count


def safe_move(src: Path, dst: Path, root: Path, dry_run: bool) -> None:
    """Move file safely using git mv if tracked, fallback to shutil.move."""
    if src == dst:
        return
    if dst.exists():
        raise FileExistsError(f"Destination already exists: {dst}")

    log_info(f"Move: {src.relative_to(root)} -> {dst.relative_to(root)}")
    if dry_run:
        return

    dst.parent.mkdir(parents=True, exist_ok=True)
    moved_with_git = False
    if (root / ".git").exists():
        try:
            res = subprocess.run(
                ["git", "mv", str(src), str(dst)],
                cwd=root,
                capture_output=True,
                text=True,
            )
            if res.returncode == 0:
                moved_with_git = True
        except (subprocess.SubprocessError, FileNotFoundError):
            pass

    if not moved_with_git:
        shutil.move(str(src), str(dst))

    # Clean up empty parent directories up to android/app/src/main/kotlin
    parent = src.parent
    kotlin_root = root / "android" / "app" / "src" / "main" / "kotlin"
    while parent != kotlin_root and parent.is_relative_to(kotlin_root):
        try:
            if parent.exists() and not any(parent.iterdir()):
                parent.rmdir()
                parent = parent.parent
            else:
                break
        except OSError:
            break


def detect_current_state(root: Path) -> dict[str, str]:
    """Detect current package and project identifiers from repository files."""
    state = {
        "app_name": "Flutter Core Base",
        "dart_name": "flutter_core_base",
        "bundle_id": "com.thanhng224.fluttercorebase",
    }
    pubspec = root / "pubspec.yaml"
    if pubspec.is_file():
        match = re.search(r"^name:\s*([a-z0-9_]+)", pubspec.read_text(encoding="utf-8"), re.MULTILINE)
        if match:
            state["dart_name"] = match.group(1)

    constants = root / "lib" / "core" / "constants" / "app_constants.dart"
    if constants.is_file():
        match = re.search(r"appName\s*=\s*'([^']+)'", constants.read_text(encoding="utf-8"))
        if match:
            state["app_name"] = match.group(1)
    else:
        gradle_file = root / "android" / "app" / "build.gradle.kts"
        if gradle_file.is_file():
            content = gradle_file.read_text(encoding="utf-8")
            name_match = re.search(r'resValue\("string",\s*"app_name",\s*"([^"]*?(?<!\sDev))"\)', content)
            if name_match:
                state["app_name"] = name_match.group(1)

    gradle_file = root / "android" / "app" / "build.gradle.kts"
    if gradle_file.is_file():
        content = gradle_file.read_text(encoding="utf-8")
        match = re.search(r'namespace\s*=\s*"([^"]+)"', content)
        if match:
            state["bundle_id"] = match.group(1)

    return state


def refactor_dart_and_flutter(root: Path, current: dict[str, str], cfg: ProjectConfig) -> None:
    """Refactor Dart package name, imports, widget names, and constants."""
    old_dart = current["dart_name"]
    new_dart = cfg.dart_name
    old_app = current["app_name"]
    new_app = cfg.app_name

    # 1. pubspec.yaml
    pubspec = root / "pubspec.yaml"
    replace_in_file(pubspec, rf"^name:\s*{re.escape(old_dart)}", f"name: {new_dart}", cfg.dry_run)

    # 2. Update imports across all dart files in lib/ and test/
    for folder in ("lib", "test"):
        dir_path = root / folder
        if not dir_path.is_dir():
            continue
        for dart_file in dir_path.rglob("*.dart"):
            replace_in_file(
                dart_file,
                rf"package:{re.escape(old_dart)}/",
                f"package:{new_dart}/",
                cfg.dry_run,
            )

    # 3. Main App widget class in lib/main.dart and lib/app/app.dart
    old_app_class = f"{to_pascal_case(old_app)}App"
    # Also handle fallback FlutterCoreBaseApp
    replace_in_file(root / "lib" / "main.dart", r"FlutterCoreBaseApp", cfg.app_class_name, cfg.dry_run)
    replace_in_file(root / "lib" / "main.dart", re.escape(old_app_class), cfg.app_class_name, cfg.dry_run)

    app_dart = root / "lib" / "app" / "app.dart"
    replace_in_file(app_dart, r"FlutterCoreBaseApp", cfg.app_class_name, cfg.dry_run)
    replace_in_file(app_dart, re.escape(old_app_class), cfg.app_class_name, cfg.dry_run)

    # 4. AppConstants & ApiEndpoints
    constants_file = root / "lib" / "core" / "constants" / "app_constants.dart"
    replace_in_file(constants_file, rf"appName\s*=\s*'[^']+'", f"appName = '{new_app}'", cfg.dry_run)

    endpoints_file = root / "lib" / "core" / "constants" / "api_endpoints.dart"
    replace_in_file(
        endpoints_file,
        rf"api\.{re.escape(old_dart)}\.com",
        f"api.{new_dart}.com",
        cfg.dry_run,
    )
    replace_in_file(
        endpoints_file,
        r"api\.fluttercorebase\.com",
        f"api.{new_dart}.com",
        cfg.dry_run,
    )
    replace_in_file(
        endpoints_file,
        r"api-dev\.fluttercorebase\.com",
        f"api-dev.{new_dart}.com",
        cfg.dry_run,
    )
    replace_in_file(
        endpoints_file,
        rf"api-dev\.{re.escape(old_dart)}\.com",
        f"api-dev.{new_dart}.com",
        cfg.dry_run,
    )

    # 5. Localization ARB files
    l10n_dir = root / "lib" / "l10n"
    if l10n_dir.is_dir():
        for arb_file in l10n_dir.glob("*.arb"):
            replace_in_file(arb_file, r'"appName":\s*"[^"]+"', f'"appName": "{new_app}"', cfg.dry_run)
        # Also sync existing generated localizations if present
        for loc_file in l10n_dir.glob("app_localizations*.dart"):
            replace_in_file(loc_file, rf"'{re.escape(old_app)}'", f"'{new_app}'", cfg.dry_run)
            replace_in_file(loc_file, r"'Flutter Core Base'", f"'{new_app}'", cfg.dry_run)


def refactor_android(root: Path, current: dict[str, str], cfg: ProjectConfig) -> None:
    """Refactor Android package, applicationId, app_name, and MainActivity."""
    old_bundle = current["bundle_id"]
    new_bundle = cfg.bundle_id
    new_app = cfg.app_name

    gradle_file = root / "android" / "app" / "build.gradle.kts"
    if gradle_file.is_file():
        replace_in_file(gradle_file, rf'namespace\s*=\s*"{re.escape(old_bundle)}"', f'namespace = "{new_bundle}"', cfg.dry_run)
        replace_in_file(gradle_file, rf'applicationId\s*=\s*"{re.escape(old_bundle)}"', f'applicationId = "{new_bundle}"', cfg.dry_run)
        replace_in_file(gradle_file, r'resValue\("string",\s*"app_name",\s*"[^"]*?\s+Dev"\)', f'resValue("string", "app_name", "{new_app} Dev")', cfg.dry_run)
        replace_in_file(gradle_file, r'resValue\("string",\s*"app_name",\s*"[^"]*?(?<!\sDev)"\)', f'resValue("string", "app_name", "{new_app}")', cfg.dry_run)

    # Relocate MainActivity.kt
    kotlin_dir = root / "android" / "app" / "src" / "main" / "kotlin"
    if kotlin_dir.is_dir():
        # Find MainActivity.kt
        main_activities = list(kotlin_dir.rglob("MainActivity.kt"))
        if main_activities:
            src_activity = main_activities[0]
            dst_activity = kotlin_dir / Path(*new_bundle.split(".")) / "MainActivity.kt"

            # Check collision before moving
            if src_activity != dst_activity and dst_activity.exists():
                raise FileExistsError(f"Target activity path already exists: {dst_activity}")

            # Update package statement
            replace_in_file(src_activity, r"^package\s+[a-zA-Z0-9_.]+", f"package {new_bundle}", cfg.dry_run)

            # Move file
            safe_move(src_activity, dst_activity, root, cfg.dry_run)


def refactor_ios_and_macos(root: Path, current: dict[str, str], cfg: ProjectConfig) -> None:
    """Refactor iOS and macOS configurations, xcconfig files, and plists."""
    old_bundle = current["bundle_id"]
    new_bundle = cfg.bundle_id
    old_app = current["app_name"]
    new_app = cfg.app_name
    old_dart = current["dart_name"]
    new_dart = cfg.dart_name
    escaped_app = escape_xml_text(new_app)

    # iOS Flavor & xcconfig
    ios_flutter = root / "ios" / "Flutter"
    if ios_flutter.is_dir():
        for cfg_file in ios_flutter.glob("*.xcconfig"):
            replace_in_file(cfg_file, rf"PRODUCT_BUNDLE_IDENTIFIER={re.escape(old_bundle)}\.dev", f"PRODUCT_BUNDLE_IDENTIFIER={new_bundle}.dev", cfg.dry_run)
            replace_in_file(cfg_file, rf"PRODUCT_BUNDLE_IDENTIFIER={re.escape(old_bundle)}", f"PRODUCT_BUNDLE_IDENTIFIER={new_bundle}", cfg.dry_run)

    # iOS project.pbxproj
    ios_pbx = root / "ios" / "Runner.xcodeproj" / "project.pbxproj"
    if ios_pbx.is_file():
        replace_in_file(ios_pbx, rf"PRODUCT_BUNDLE_IDENTIFIER\s*=\s*{re.escape(old_bundle)};", f"PRODUCT_BUNDLE_IDENTIFIER = {new_bundle};", cfg.dry_run)

    # iOS Info.plist
    ios_info = root / "ios" / "Runner" / "Info.plist"
    if ios_info.is_file():
        replace_in_file(
            ios_info,
            r"(<key>CFBundleDisplayName</key>\s*<string>)[^<]+(</string>)",
            rf"\g<1>{escaped_app}\g<2>",
            cfg.dry_run,
        )
        replace_in_file(
            ios_info,
            r"(<key>CFBundleName</key>\s*<string>)[^<]+(</string>)",
            rf"\g<1>{new_dart}\g<2>",
            cfg.dry_run,
        )

    # macOS AppInfo.xcconfig
    macos_app_info = root / "macos" / "Runner" / "Configs" / "AppInfo.xcconfig"
    if macos_app_info.is_file():
        replace_in_file(macos_app_info, rf"PRODUCT_NAME\s*=\s*.*", f"PRODUCT_NAME = {new_app}", cfg.dry_run)
        replace_in_file(macos_app_info, rf"PRODUCT_BUNDLE_IDENTIFIER\s*=\s*{re.escape(old_bundle)}", f"PRODUCT_BUNDLE_IDENTIFIER = {new_bundle}", cfg.dry_run)
        replace_in_file(macos_app_info, r"PRODUCT_COPYRIGHT\s*=\s*.*", f"PRODUCT_COPYRIGHT = Copyright © 2026 {new_app}. All rights reserved.", cfg.dry_run)

    # macOS project.pbxproj & schemes
    macos_pbx = root / "macos" / "Runner.xcodeproj" / "project.pbxproj"
    if macos_pbx.is_file():
        replace_in_file(macos_pbx, rf'INFOPLIST_KEY_CFBundleDisplayName\s*=\s*"[^"]+";', f'INFOPLIST_KEY_CFBundleDisplayName = "{new_app}";', cfg.dry_run)
        replace_in_file(macos_pbx, rf'path\s*=\s*"{re.escape(old_app)}\.app"', f'path = "{new_app}.app"', cfg.dry_run)
        replace_in_file(macos_pbx, rf'/\*\s*{re.escape(old_app)}\.app\s*\*/', f'/* {new_app}.app */', cfg.dry_run)

    macos_scheme = root / "macos" / "Runner.xcodeproj" / "xcshareddata" / "xcschemes" / "Runner.xcscheme"
    if macos_scheme.is_file():
        replace_in_file(macos_scheme, rf'BuildableName\s*=\s*"{re.escape(old_app)}\.app"', f'BuildableName = "{new_app}.app"', cfg.dry_run)


def refactor_web_and_desktop(root: Path, current: dict[str, str], cfg: ProjectConfig) -> None:
    """Refactor Web and Windows platform targets."""
    old_app = current["app_name"]
    new_app = cfg.app_name
    old_dart = current["dart_name"]
    new_dart = cfg.dart_name

    # Web index.html & manifest.json
    web_index = root / "web" / "index.html"
    if web_index.is_file():
        replace_in_file(web_index, r"<title>[^<]+</title>", f"<title>{new_app}</title>", cfg.dry_run)
        replace_in_file(web_index, r'content="[a-z0-9_]+"(?=\s*>\s*\n\s*<link rel="apple-touch-icon")', f'content="{new_dart}"', cfg.dry_run)
        replace_in_file(web_index, rf'content="{re.escape(old_dart)}"', f'content="{new_dart}"', cfg.dry_run)

    web_manifest = root / "web" / "manifest.json"
    if web_manifest.is_file():
        replace_in_file(web_manifest, r'"name":\s*"[^"]+"', f'"name": "{new_app}"', cfg.dry_run)
        replace_in_file(web_manifest, r'"short_name":\s*"[^"]+"', f'"short_name": "{cfg.short_name}"', cfg.dry_run)

    # Windows CMakeLists.txt & Runner.rc & main.cpp
    win_cmake = root / "windows" / "CMakeLists.txt"
    if win_cmake.is_file():
        replace_in_file(win_cmake, rf"project\({re.escape(old_dart)}\s+LANGUAGES", f"project({new_dart} LANGUAGES", cfg.dry_run)
        replace_in_file(win_cmake, rf'set\(BINARY_NAME\s+"{re.escape(old_dart)}"\)', f'set(BINARY_NAME "{new_dart}")', cfg.dry_run)

    win_rc = root / "windows" / "runner" / "Runner.rc"
    if win_rc.is_file():
        replace_in_file(win_rc, rf'VALUE "CompanyName",\s*"[^"]*"', f'VALUE "CompanyName", "{new_app}"', cfg.dry_run)
        replace_in_file(win_rc, rf'VALUE "FileDescription",\s*"[^"]*"', f'VALUE "FileDescription", "{new_app} Application"', cfg.dry_run)
        replace_in_file(win_rc, rf'VALUE "InternalName",\s*"[^"]*"', f'VALUE "InternalName", "{new_dart}"', cfg.dry_run)
        replace_in_file(win_rc, rf'VALUE "LegalCopyright",\s*"[^"]*"', f'VALUE "LegalCopyright", "Copyright (C) 2026 {new_app}. All rights reserved."', cfg.dry_run)
        replace_in_file(win_rc, rf'VALUE "OriginalFilename",\s*"[^"]*"', f'VALUE "OriginalFilename", "{new_dart}.exe"', cfg.dry_run)
        replace_in_file(win_rc, rf'VALUE "ProductName",\s*"[^"]*"', f'VALUE "ProductName", "{new_app}"', cfg.dry_run)

    win_main = root / "windows" / "runner" / "main.cpp"
    if win_main.is_file():
        replace_in_file(win_main, rf'CreateAndShow\(L"[^"]*"', f'CreateAndShow(L"{new_app}"', cfg.dry_run)


HOME_SCREEN_DART_TEMPLATE = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:{dart_name}/core/config/app_config_controller.dart';
import 'package:{dart_name}/core/constants/app_constants.dart';
import 'package:{dart_name}/core/extensions/context_extensions.dart';
import 'package:{dart_name}/core/routing/route_paths.dart';
import 'package:{dart_name}/core/theme/app_colors.dart';
import 'package:{dart_name}/core/theme/app_semantic_colors.dart';
import 'package:{dart_name}/core/theme/app_spacing.dart';
import 'package:{dart_name}/core/theme/app_typography.dart';
import 'package:{dart_name}/core/widgets/app_button.dart';
import 'package:{dart_name}/core/widgets/app_card.dart';

/// Clean starter home screen for {app_name}.
class HomeScreen extends ConsumerWidget {{
  const HomeScreen({{super.key}});

  @override
  Widget build(BuildContext context, WidgetRef ref) {{
    final configState = ref.watch(appConfigControllerProvider);
    final envName = configState.value?.environment.name.toUpperCase() ?? '';
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTooltip,
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.appName,
                              style: AppTypography.titleLarge,
                            ),
                            if (envName.isNotEmpty)
                              Text(
                                envName,
                                style: AppTypography.labelMedium.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Starter base initialized successfully. Build new feature modules inside lib/features/.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.l),
                  AppButton(
                    label: l10n.developerSdkSettingsTitle,
                    icon: Icons.settings_outlined,
                    onPressed: () => context.push(RoutePaths.settings),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}
}}
"""

HOME_SCREEN_TEST_TEMPLATE = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{dart_name}/core/constants/app_constants.dart';
import 'package:{dart_name}/features/home/presentation/home_screen.dart';

import '../../support/widget_harness.dart';

void main() {{
  testWidgets('HomeScreen renders app name and settings action', (tester) async {{
    await tester.pumpWidget(
      ProviderScope(
        child: harness(
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.byIcon(Icons.settings_outlined), findsWidgets);
  }});
}}
"""

ROUTE_PATHS_CLEAN_TEMPLATE = """/// Centralized route paths for GoRouter
abstract class RoutePaths {
  static const String home = '/';
  static const String settings = '/settings';
}
"""

APP_ROUTER_CLEAN_TEMPLATE = """import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{dart_name}/core/extensions/context_extensions.dart';
import 'package:{dart_name}/core/routing/route_paths.dart';
import 'package:{dart_name}/features/home/presentation/home_screen.dart';
import 'package:{dart_name}/features/settings/presentation/settings_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {{
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          context.l10n.pageNotFoundMessage(state.uri.toString()),
        ),
      ),
    ),
  );
}}
"""


def clean_sample_code(root: Path, cfg: ProjectConfig) -> None:
    """Remove sample features (posts, catalog) and wire a clean HomeScreen."""
    log_info("Cleaning sample feature code (posts & catalog)...")

    # Folders to delete
    sample_dirs = [
        root / "lib" / "features" / "posts",
        root / "lib" / "features" / "catalog",
        root / "test" / "features" / "posts",
        root / "test" / "features" / "catalog",
    ]

    home_screen_file = root / "lib" / "features" / "home" / "presentation" / "home_screen.dart"
    if home_screen_file.exists() and not cfg.dry_run:
        raise FileExistsError(
            f"Refusing to overwrite existing clean starter screen: {home_screen_file}"
        )

    for d in sample_dirs:
        if d.is_dir():
            log_info(f"Remove directory: {d.relative_to(root)}")
            if not cfg.dry_run:
                shutil.rmtree(d)

    # Update route_paths.dart
    route_paths_file = root / "lib" / "core" / "routing" / "route_paths.dart"
    if not cfg.dry_run:
        route_paths_file.write_text(ROUTE_PATHS_CLEAN_TEMPLATE, encoding="utf-8")

    # Update app_router.dart
    app_router_file = root / "lib" / "core" / "routing" / "app_router.dart"
    if not cfg.dry_run:
        content = APP_ROUTER_CLEAN_TEMPLATE.format(dart_name=cfg.dart_name)
        app_router_file.write_text(content, encoding="utf-8")

    # Create features/home/presentation/home_screen.dart
    home_dir = root / "lib" / "features" / "home" / "presentation"
    home_screen_file = home_dir / "home_screen.dart"
    if not cfg.dry_run:
        home_dir.mkdir(parents=True, exist_ok=True)
        content = HOME_SCREEN_DART_TEMPLATE.format(
            dart_name=cfg.dart_name,
            app_name=cfg.app_name,
        )
        home_screen_file.write_text(content, encoding="utf-8")

    # Create test/features/home/home_screen_test.dart
    test_home_dir = root / "test" / "features" / "home"
    test_home_file = test_home_dir / "home_screen_test.dart"
    if not cfg.dry_run:
        test_home_dir.mkdir(parents=True, exist_ok=True)
        content = HOME_SCREEN_TEST_TEMPLATE.format(dart_name=cfg.dart_name)
        test_home_file.write_text(content, encoding="utf-8")

    # Clean endpoints references to posts
    endpoints_file = root / "lib" / "core" / "constants" / "api_endpoints.dart"
    replace_in_file(endpoints_file, r"\s*static const String posts = '/posts';\n", "", cfg.dry_run)


def run_code_generation_and_verification(root: Path, cfg: ProjectConfig) -> bool:
    """Execute pub get, build_runner, dart format, flutter analyze, and flutter test."""
    if cfg.dry_run:
        log_info("[Dry Run] Would execute: flutter pub get")
        log_info("[Dry Run] Would execute: flutter gen-l10n")
        log_info("[Dry Run] Would execute: dart run build_runner build")
        log_info("[Dry Run] Would execute: dart format .")
        if not cfg.skip_build_check:
            log_info("[Dry Run] Would execute: flutter analyze --fatal-infos && flutter test")
        return True

    # Check flutter and dart availability
    if not shutil.which("flutter") or not shutil.which("dart"):
        log_warn("Flutter/Dart SDK not found in PATH; skipping automated code generation and verification.")
        return True

    commands = [
        ("Resolving dependencies", ["flutter", "pub", "get"]),
        ("Generating localizations", ["flutter", "gen-l10n"]),
        ("Running build_runner code generation", ["dart", "run", "build_runner", "build"]),
        ("Formatting Dart source files", ["dart", "format", "."]),
    ]

    for desc, cmd in commands:
        log_info(f"{desc} ({' '.join(cmd)})...")
        res = subprocess.run(cmd, cwd=root, capture_output=True, text=True)
        if res.returncode != 0:
            log_error(f"Command failed: {' '.join(cmd)}")
            if res.stderr.strip():
                print(f"{RED}{res.stderr.strip()}{RESET}")
            elif res.stdout.strip():
                print(f"{RED}{res.stdout.strip()}{RESET}")
            return False

    if not cfg.skip_build_check:
        verify_commands = [
            ("Running code analysis", ["flutter", "analyze", "--fatal-infos"]),
            ("Running test suite", ["flutter", "test"]),
        ]
        for desc, cmd in verify_commands:
            log_info(f"{desc} ({' '.join(cmd)})...")
            res = subprocess.run(cmd, cwd=root, capture_output=True, text=True)
            if res.returncode != 0:
                log_error(f"Verification check failed: {' '.join(cmd)}")
                if res.stderr.strip():
                    print(f"{RED}{res.stderr.strip()}{RESET}")
                elif res.stdout.strip():
                    print(f"{RED}{res.stdout.strip()}{RESET}")
                return False

    return True


def interactive_wizard(current: dict[str, str], cli_args: argparse.Namespace) -> ProjectConfig:
    """Run interactive terminal wizard, inheriting CLI flags passed by user."""
    print(f"\n{BOLD}{BLUE}=== Flutter Project Initialization Wizard ==={RESET}\n")

    # 1. App Name
    default_app = cli_args.app_name or current["app_name"]
    while True:
        prompt = f"App Display Name [{default_app}]: "
        try:
            val = input(prompt).strip()
        except EOFError:
            val = default_app
        val = val or default_app
        ok, err = validate_app_name(val)
        if ok:
            chosen_app = val
            break
        print(f"{RED}Error: {err}{RESET}")

    # 2. Dart Package Name
    suggested_dart = suggest_dart_name(chosen_app)
    default_dart = cli_args.dart_name or (suggested_dart if chosen_app != current["app_name"] else current["dart_name"])
    while True:
        prompt = f"Dart Package Name (snake_case) [{default_dart}]: "
        try:
            val = input(prompt).strip()
        except EOFError:
            val = default_dart
        val = val or default_dart
        ok, err = validate_dart_name(val)
        if ok:
            chosen_dart = val
            break
        print(f"{RED}Error: {err}{RESET}")

    # 3. Application ID / Bundle ID
    suggested_bundle = suggest_bundle_id(chosen_app)
    default_bundle = cli_args.bundle_id or (suggested_bundle if chosen_app != current["app_name"] else current["bundle_id"])
    while True:
        prompt = f"Application ID / Bundle ID [{default_bundle}]: "
        try:
            val = input(prompt).strip()
        except EOFError:
            val = default_bundle
        val = val or default_bundle
        ok, err = validate_bundle_id(val)
        if ok:
            chosen_bundle = val
            break
        print(f"{RED}Error: {err}{RESET}")

    # 4. Clean Samples Option (inherits cli_args.clean_samples if set)
    clean_default_str = "y" if cli_args.clean_samples else "n"
    while True:
        prompt = f"Clean sample code (posts & catalog demo features)? [y/N]: "
        if cli_args.clean_samples:
            prompt = f"Clean sample code (posts & catalog demo features)? [Y/n]: "
        try:
            val = input(prompt).strip().lower()
        except EOFError:
            val = clean_default_str
        if not val:
            val = clean_default_str
        if val in ("y", "yes"):
            chosen_clean = True
            break
        elif val in ("n", "no"):
            chosen_clean = False
            break
        print(f"{RED}Please enter 'y' or 'n'.{RESET}")

    return ProjectConfig(
        app_name=chosen_app,
        dart_name=chosen_dart,
        bundle_id=chosen_bundle,
        clean_samples=chosen_clean,
        dry_run=cli_args.dry_run,
        force=cli_args.force,
        skip_build_check=cli_args.skip_build_check,
    )


def parse_arguments() -> argparse.Namespace:
    """Parse command line flags."""
    parser = argparse.ArgumentParser(
        description="Rebrand and initialize a FlutterCoreBase project.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--app-name", help='User-facing application name (e.g. "Acme Shop")')
    parser.add_argument("--dart-name", help='Dart package name (snake_case, e.g. "acme_shop")')
    parser.add_argument("--bundle-id", help='Application ID / Bundle Identifier (e.g. "com.acme.shop")')
    parser.add_argument("--clean-samples", action="store_true", help="Remove demo features (posts and catalog)")
    parser.add_argument("--dry-run", action="store_true", help="Preview modifications without touching filesystem")
    parser.add_argument("--force", action="store_true", help="Bypass git uncommitted changes check")
    parser.add_argument("--skip-build-check", action="store_true", help="Skip flutter analyze and flutter test checks")
    return parser.parse_args()


def main() -> int:
    args = parse_arguments()

    try:
        root = find_project_root()
    except FileNotFoundError as e:
        log_error(str(e))
        return 1

    current = detect_current_state(root)

    # Determine execution mode: interactive vs headless
    is_headless = bool(args.app_name and args.dart_name and args.bundle_id)

    if is_headless:
        ok, err = validate_app_name(args.app_name)
        if not ok:
            log_error(f"Invalid --app-name: {err}")
            return 1

        ok, err = validate_dart_name(args.dart_name)
        if not ok:
            log_error(f"Invalid --dart-name: {err}")
            return 1

        ok, err = validate_bundle_id(args.bundle_id)
        if not ok:
            log_error(f"Invalid --bundle-id: {err}")
            return 1

        cfg = ProjectConfig(
            app_name=args.app_name.strip(),
            dart_name=args.dart_name.strip(),
            bundle_id=args.bundle_id.strip(),
            clean_samples=args.clean_samples,
            dry_run=args.dry_run,
            force=args.force,
            skip_build_check=args.skip_build_check,
        )
    else:
        cfg = interactive_wizard(current, args)

    # Check git clean status
    if not cfg.dry_run and not check_git_clean(root, cfg.force):
        return 1

    # Pre-flight collision check
    kotlin_dir = root / "android" / "app" / "src" / "main" / "kotlin"
    if kotlin_dir.is_dir():
        main_activities = list(kotlin_dir.rglob("MainActivity.kt"))
        if main_activities:
            src_activity = main_activities[0]
            dst_activity = kotlin_dir / Path(*cfg.bundle_id.split(".")) / "MainActivity.kt"
            if src_activity != dst_activity and dst_activity.exists():
                log_error(f"Collision detected: Target activity {dst_activity.relative_to(root)} already exists. Aborting.")
                return 1

    if cfg.clean_samples:
        home_screen_file = root / "lib" / "features" / "home" / "presentation" / "home_screen.dart"
        if home_screen_file.exists():
            log_error(f"Collision detected: Clean starter screen {home_screen_file.relative_to(root)} already exists. Aborting.")
            return 1

    print(f"\n{BOLD}=== Project Initialization Summary ==={RESET}")
    print(f"  App Display Name:   {GREEN}{cfg.app_name}{RESET}")
    print(f"  Dart Package:       {GREEN}{cfg.dart_name}{RESET}")
    print(f"  Bundle Identifier:  {GREEN}{cfg.bundle_id}{RESET}")
    print(f"  Clean Samples:      {YELLOW if cfg.clean_samples else GREEN}{cfg.clean_samples}{RESET}")
    print(f"  Dry Run:            {YELLOW if cfg.dry_run else RESET}{cfg.dry_run}{RESET}")
    print(f"======================================\n")

    try:
        log_info("Refactoring Dart package and Flutter app...")
        refactor_dart_and_flutter(root, current, cfg)

        log_info("Refactoring Android module...")
        refactor_android(root, current, cfg)

        log_info("Refactoring iOS and macOS targets...")
        refactor_ios_and_macos(root, current, cfg)

        log_info("Refactoring Web and Windows targets...")
        refactor_web_and_desktop(root, current, cfg)

        if cfg.clean_samples:
            clean_sample_code(root, cfg)

        log_info("Post-processing: code generation, formatting, and verification...")
        success = run_code_generation_and_verification(root, cfg)
        if not success:
            log_error("Initialization completed with verification warnings or errors.")
            return 1

    except Exception as e:
        log_error(f"An unexpected error occurred during initialization: {e}")
        return 1

    if cfg.dry_run:
        log_success("Dry run completed successfully. No files were modified.")
    else:
        log_success("Project initialization complete! Your Flutter starter is ready.")
        print("\nNext steps:")
        print("  1. Review changes with: git status && git diff")
        print("  2. Run development flavor: flutter run --flavor dev")

    return 0


if __name__ == "__main__":
    sys.exit(main())
