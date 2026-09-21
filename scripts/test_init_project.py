#!/usr/bin/env python3
"""
Unit tests for FlutterCoreBase scripts/init_project.py
"""

from __future__ import annotations

import argparse
import os
import plistlib
import shutil
import tempfile
import unittest
from pathlib import Path

from init_project import (
    ProjectConfig,
    clean_sample_code,
    detect_current_state,
    interactive_wizard,
    parse_arguments,
    refactor_android,
    refactor_dart_and_flutter,
    refactor_ios_and_macos,
    refactor_web_and_desktop,
    safe_move,
    suggest_bundle_id,
    suggest_dart_name,
    to_pascal_case,
    validate_app_name,
    validate_bundle_id,
    validate_dart_name,
)


class TestValidators(unittest.TestCase):
    def test_validate_app_name_valid(self):
        ok, err = validate_app_name("Acme Shop")
        self.assertTrue(ok)
        self.assertEqual(err, "")

    def test_validate_app_name_empty(self):
        ok, err = validate_app_name("   ")
        self.assertFalse(ok)
        self.assertIn("cannot be empty", err)

    def test_validate_app_name_too_long(self):
        ok, err = validate_app_name("A" * 51)
        self.assertFalse(ok)
        self.assertIn("cannot exceed 50", err)

    def test_validate_app_name_invalid_chars(self):
        for char in ('"', "<", ">", "\n", "\0"):
            ok, err = validate_app_name(f"My{char}App")
            self.assertFalse(ok)
            self.assertIn("invalid characters", err)

    def test_validate_app_name_allows_ampersand(self):
        ok, err = validate_app_name("Acme & Shop")
        self.assertTrue(ok, err)

    def test_validate_dart_name_valid(self):
        for valid in ("acme_shop", "my_app_123", "core_base"):
            ok, err = validate_dart_name(valid)
            self.assertTrue(ok, f"Expected {valid} to be valid, got: {err}")

    def test_validate_dart_name_invalid(self):
        cases = [
            ("AcmeShop", "snake_case"),
            ("123app", "start with a lowercase letter"),
            ("my-app", "snake_case"),
            ("my app", "snake_case"),
            ("class", "reserved Dart keyword"),
            ("flutter", "reserved Dart keyword"),
            ("flutter_test", "reserved Dart keyword"),
        ]
        for name, expected_err in cases:
            ok, err = validate_dart_name(name)
            self.assertFalse(ok, f"Expected {name} to be invalid")
            self.assertIn(expected_err, err)

    def test_validate_bundle_id_valid(self):
        for valid in ("com.example.app", "vn.thanhng.shop", "io.github.base_app"):
            ok, err = validate_bundle_id(valid)
            self.assertTrue(ok, f"Expected {valid} to be valid, got: {err}")

    def test_validate_bundle_id_invalid(self):
        cases = [
            ("", "cannot be empty"),
            ("com", "reverse-domain"),
            ("com..app", "cannot contain empty segments"),
            ("com.123app.demo", "cannot start with a digit"),
            ("com.example.app!", "contains invalid characters"),
        ]
        for bundle, expected_err in cases:
            ok, err = validate_bundle_id(bundle)
            self.assertFalse(ok, f"Expected {bundle} to be invalid")
            self.assertIn(expected_err, err)


class TestNamingHelpers(unittest.TestCase):
    def test_suggest_dart_name(self):
        self.assertEqual(suggest_dart_name("Acme Shop"), "acme_shop")
        self.assertEqual(suggest_dart_name("Acme & Sons!"), "acme_sons")
        self.assertEqual(suggest_dart_name("123 Delivery"), "app_123_delivery")
        self.assertEqual(suggest_dart_name("class"), "class_app")

    def test_suggest_bundle_id(self):
        self.assertEqual(suggest_bundle_id("Acme Shop"), "com.example.acmeshop")
        self.assertEqual(suggest_bundle_id("Super App 2"), "com.example.superapp2")
        self.assertEqual(suggest_bundle_id("123 App"), "com.example.app123app")

    def test_to_pascal_case(self):
        self.assertEqual(to_pascal_case("acme_shop"), "AcmeShop")
        self.assertEqual(to_pascal_case("Acme Shop"), "AcmeShop")
        self.assertEqual(to_pascal_case("flutter_core_base"), "FlutterCoreBase")


class TestProjectConfig(unittest.TestCase):
    def test_computed_properties(self):
        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
        )
        self.assertEqual(cfg.app_class_name, "AcmeShopApp")
        self.assertEqual(cfg.short_name, "AcmeShop")

    def test_app_class_name_is_valid_when_display_name_starts_with_digit(self):
        cfg = ProjectConfig(
            app_name="123 Shop",
            dart_name="shop_app",
            bundle_id="com.acme.shop",
        )
        self.assertEqual(cfg.app_class_name, "App123ShopApp")


class TestFlagInheritanceAndWizard(unittest.TestCase):
    def test_wizard_inherits_flags(self):
        current = {
            "app_name": "Flutter Core Base",
            "dart_name": "flutter_core_base",
            "bundle_id": "com.thanhng224.fluttercorebase",
        }
        cli_args = argparse.Namespace(
            app_name="Test App",
            dart_name="test_app",
            bundle_id="com.example.testapp",
            clean_samples=True,
            dry_run=True,
            force=True,
            skip_build_check=True,
        )

        import builtins
        original_input = builtins.input
        try:
            # When user accepts defaults at every prompt
            builtins.input = lambda prompt: ""
            cfg = interactive_wizard(current, cli_args)
            self.assertEqual(cfg.app_name, "Test App")
            self.assertEqual(cfg.dart_name, "test_app")
            self.assertEqual(cfg.bundle_id, "com.example.testapp")
            self.assertTrue(cfg.clean_samples)
            self.assertTrue(cfg.dry_run)
            self.assertTrue(cfg.force)
            self.assertTrue(cfg.skip_build_check)
        finally:
            builtins.input = original_input


class TestRefactoringOperations(unittest.TestCase):
    def setUp(self):
        self.temp_dir = Path(tempfile.mkdtemp())
        self.root = self.temp_dir / "project"
        self.root.mkdir()

        # Create basic directory structure
        (self.root / "lib" / "app").mkdir(parents=True)
        (self.root / "lib" / "core" / "constants").mkdir(parents=True)
        (self.root / "lib" / "core" / "routing").mkdir(parents=True)
        (self.root / "lib" / "app" / "routing").mkdir(parents=True)
        (self.root / "lib" / "features" / "auth" / "presentation").mkdir(parents=True)
        (self.root / "test" / "features" / "auth").mkdir(parents=True)
        (self.root / "lib" / "l10n").mkdir(parents=True)
        (self.root / "test" / "support").mkdir(parents=True)
        (self.root / "android" / "app" / "src" / "main" / "kotlin" / "com" / "thanhng224" / "fluttercorebase").mkdir(parents=True)
        (self.root / "ios" / "Flutter").mkdir(parents=True)
        (self.root / "ios" / "Runner.xcodeproj").mkdir(parents=True)
        (self.root / "ios" / "Runner").mkdir(parents=True)
        (self.root / "macos" / "Runner" / "Configs").mkdir(parents=True)
        (self.root / "macos" / "Runner.xcodeproj" / "xcshareddata" / "xcschemes").mkdir(parents=True)
        (self.root / "web").mkdir(parents=True)
        (self.root / "windows" / "runner").mkdir(parents=True)

        # Setup mock files
        (self.root / "pubspec.yaml").write_text("name: flutter_core_base\nversion: 1.0.0\n", encoding="utf-8")
        (self.root / "lib" / "main.dart").write_text(
            "import 'package:flutter_core_base/app/app.dart';\nvoid main() => runApp(const FlutterCoreBaseApp());\n",
            encoding="utf-8",
        )
        (self.root / "lib" / "app" / "app.dart").write_text(
            "class FlutterCoreBaseApp extends ConsumerWidget {\n  const FlutterCoreBaseApp({super.key});\n}\n",
            encoding="utf-8",
        )
        (self.root / "lib" / "core" / "constants" / "app_constants.dart").write_text(
            "abstract class AppConstants {\n  static const String appName = 'Flutter Core Base';\n}\n",
            encoding="utf-8",
        )
        (self.root / "lib" / "core" / "constants" / "api_endpoints.dart").write_text(
            "abstract class ApiEndpoints {\n  static const String prodUrl = 'https://api.fluttercorebase.com';\n  static const String devUrl = 'https://api-dev.fluttercorebase.com';\n  static const String posts = '/posts';\n}\n",
            encoding="utf-8",
        )
        (self.root / "lib" / "l10n" / "app_en.arb").write_text(
            '{\n  "appName": "Flutter Core Base"\n}\n',
            encoding="utf-8",
        )
        (self.root / "android" / "app" / "build.gradle.kts").write_text(
            'namespace = "com.thanhng224.fluttercorebase"\napplicationId = "com.thanhng224.fluttercorebase"\nresValue("string", "app_name", "Flutter Core Base")\n',
            encoding="utf-8",
        )
        (self.root / "android" / "app" / "src" / "main" / "kotlin" / "com" / "thanhng224" / "fluttercorebase" / "MainActivity.kt").write_text(
            "package com.thanhng224.fluttercorebase\nimport io.flutter.embedding.android.FlutterActivity\nclass MainActivity : FlutterActivity()\n",
            encoding="utf-8",
        )
        (self.root / "ios" / "Flutter" / "Flavor.xcconfig").write_text(
            "PRODUCT_BUNDLE_IDENTIFIER=com.thanhng224.fluttercorebase\n",
            encoding="utf-8",
        )
        (self.root / "ios" / "Flutter" / "Debug-dev.xcconfig").write_text(
            "PRODUCT_BUNDLE_IDENTIFIER=com.thanhng224.fluttercorebase.dev\n",
            encoding="utf-8",
        )
        (self.root / "ios" / "Runner.xcodeproj" / "project.pbxproj").write_text(
            "PRODUCT_BUNDLE_IDENTIFIER = com.thanhng224.fluttercorebase;\n",
            encoding="utf-8",
        )
        (self.root / "ios" / "Runner" / "Info.plist").write_text(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
            "<plist version=\"1.0\"><dict>\n"
            "<key>CFBundleDisplayName</key>\n<string>Flutter Core Base</string>\n"
            "<key>CFBundleName</key>\n<string>flutter_core_base</string>\n"
            "</dict></plist>",
            encoding="utf-8",
        )
        (self.root / "macos" / "Runner" / "Configs" / "AppInfo.xcconfig").write_text(
            "PRODUCT_NAME = Flutter Core Base\nPRODUCT_BUNDLE_IDENTIFIER = com.thanhng224.fluttercorebase\n",
            encoding="utf-8",
        )
        (self.root / "macos" / "Runner.xcodeproj" / "project.pbxproj").write_text(
            'INFOPLIST_KEY_CFBundleDisplayName = "Flutter Core Base";\npath = "Flutter Core Base.app";\n/* Flutter Core Base.app */\n',
            encoding="utf-8",
        )
        (self.root / "macos" / "Runner.xcodeproj" / "xcshareddata" / "xcschemes" / "Runner.xcscheme").write_text(
            'BuildableName = "Flutter Core Base.app"\n',
            encoding="utf-8",
        )
        (self.root / "web" / "index.html").write_text(
            '<title>Flutter Core Base</title>\n<meta name="apple-mobile-web-app-title" content="flutter_core_base">\n<link rel="apple-touch-icon">\n',
            encoding="utf-8",
        )
        (self.root / "web" / "manifest.json").write_text(
            '{\n  "name": "Flutter Core Base",\n  "short_name": "FlutterCoreBase"\n}\n',
            encoding="utf-8",
        )
        (self.root / "windows" / "CMakeLists.txt").write_text(
            'project(flutter_core_base LANGUAGES CXX)\nset(BINARY_NAME "flutter_core_base")\n',
            encoding="utf-8",
        )
        (self.root / "windows" / "runner" / "Runner.rc").write_text(
            'VALUE "CompanyName", "Flutter Core Base"\nVALUE "FileDescription", "Flutter Core Base Starter Application"\nVALUE "InternalName", "flutter_core_base"\nVALUE "OriginalFilename", "flutter_core_base.exe"\nVALUE "ProductName", "Flutter Core Base"\n',
            encoding="utf-8",
        )
        (self.root / "windows" / "runner" / "main.cpp").write_text(
            'if (!window.CreateAndShow(L"Flutter Core Base", origin, size)) return false;\n',
            encoding="utf-8",
        )

    def tearDown(self):
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_detect_current_state(self):
        state = detect_current_state(self.root)
        self.assertEqual(state["dart_name"], "flutter_core_base")
        self.assertEqual(state["bundle_id"], "com.thanhng224.fluttercorebase")
        self.assertEqual(state["app_name"], "Flutter Core Base")

    def test_dry_run_does_not_modify_files(self):
        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
            dry_run=True,
        )
        current = detect_current_state(self.root)
        refactor_dart_and_flutter(self.root, current, cfg)
        refactor_android(self.root, current, cfg)

        # Verify pubspec.yaml remains untouched
        pubspec_content = (self.root / "pubspec.yaml").read_text(encoding="utf-8")
        self.assertIn("name: flutter_core_base", pubspec_content)

        # Verify MainActivity.kt wasn't moved
        src_activity = self.root / "android" / "app" / "src" / "main" / "kotlin" / "com" / "thanhng224" / "fluttercorebase" / "MainActivity.kt"
        self.assertTrue(src_activity.exists())

    def test_full_refactor_execution(self):
        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
            dry_run=False,
        )
        current = detect_current_state(self.root)

        refactor_dart_and_flutter(self.root, current, cfg)
        refactor_android(self.root, current, cfg)
        refactor_ios_and_macos(self.root, current, cfg)
        refactor_web_and_desktop(self.root, current, cfg)

        # 1. Dart / Flutter checks
        pubspec_content = (self.root / "pubspec.yaml").read_text(encoding="utf-8")
        self.assertIn("name: acme_shop", pubspec_content)

        main_dart = (self.root / "lib" / "main.dart").read_text(encoding="utf-8")
        self.assertIn("package:acme_shop/app/app.dart", main_dart)
        self.assertIn("AcmeShopApp", main_dart)

        app_dart = (self.root / "lib" / "app" / "app.dart").read_text(encoding="utf-8")
        self.assertIn("class AcmeShopApp extends ConsumerWidget", app_dart)

        app_constants = (self.root / "lib" / "core" / "constants" / "app_constants.dart").read_text(encoding="utf-8")
        self.assertIn("appName = 'Acme Shop'", app_constants)

        api_endpoints = (self.root / "lib" / "core" / "constants" / "api_endpoints.dart").read_text(encoding="utf-8")
        self.assertIn("api.acme_shop.com", api_endpoints)
        self.assertIn("api-dev.acme_shop.com", api_endpoints)

        arb_content = (self.root / "lib" / "l10n" / "app_en.arb").read_text(encoding="utf-8")
        self.assertIn('"appName": "Acme Shop"', arb_content)

        # 2. Android checks
        gradle_content = (self.root / "android" / "app" / "build.gradle.kts").read_text(encoding="utf-8")
        self.assertIn('namespace = "com.acme.shop"', gradle_content)
        self.assertIn('applicationId = "com.acme.shop"', gradle_content)
        self.assertIn('"Acme Shop"', gradle_content)

        new_activity = self.root / "android" / "app" / "src" / "main" / "kotlin" / "com" / "acme" / "shop" / "MainActivity.kt"
        self.assertTrue(new_activity.exists())
        self.assertIn("package com.acme.shop", new_activity.read_text(encoding="utf-8"))

        # Check old directories cleaned up
        old_dir = self.root / "android" / "app" / "src" / "main" / "kotlin" / "com" / "thanhng224"
        self.assertFalse(old_dir.exists())

        # 3. iOS checks
        flavor_content = (self.root / "ios" / "Flutter" / "Flavor.xcconfig").read_text(encoding="utf-8")
        self.assertIn("PRODUCT_BUNDLE_IDENTIFIER=com.acme.shop", flavor_content)

        dev_flavor = (self.root / "ios" / "Flutter" / "Debug-dev.xcconfig").read_text(encoding="utf-8")
        self.assertIn("PRODUCT_BUNDLE_IDENTIFIER=com.acme.shop.dev", dev_flavor)

        ios_info = (self.root / "ios" / "Runner" / "Info.plist").read_text(encoding="utf-8")
        self.assertIn("<string>Acme Shop</string>", ios_info)
        self.assertIn("<string>acme_shop</string>", ios_info)
        plistlib.loads((self.root / "ios" / "Runner" / "Info.plist").read_bytes())

        # 4. macOS checks
        macos_info = (self.root / "macos" / "Runner" / "Configs" / "AppInfo.xcconfig").read_text(encoding="utf-8")
        self.assertIn("PRODUCT_NAME = Acme Shop", macos_info)
        self.assertIn("PRODUCT_BUNDLE_IDENTIFIER = com.acme.shop", macos_info)

        # 5. Web checks
        web_index = (self.root / "web" / "index.html").read_text(encoding="utf-8")
        self.assertIn("<title>Acme Shop</title>", web_index)
        self.assertIn('content="acme_shop"', web_index)

        manifest = (self.root / "web" / "manifest.json").read_text(encoding="utf-8")
        self.assertIn('"name": "Acme Shop"', manifest)
        self.assertIn('"short_name": "AcmeShop"', manifest)

        # 6. Windows checks
        win_cmake = (self.root / "windows" / "CMakeLists.txt").read_text(encoding="utf-8")
        self.assertIn("project(acme_shop LANGUAGES", win_cmake)
        self.assertIn('set(BINARY_NAME "acme_shop")', win_cmake)

        win_rc = (self.root / "windows" / "runner" / "Runner.rc").read_text(encoding="utf-8")
        self.assertIn('"Acme Shop"', win_rc)
        self.assertIn('"acme_shop"', win_rc)

    def test_collision_detection(self):
        # Create a pre-existing target file at the new package path
        target_path = self.root / "android" / "app" / "src" / "main" / "kotlin" / "com" / "acme" / "shop" / "MainActivity.kt"
        target_path.parent.mkdir(parents=True)
        target_path.write_text("// Existing file", encoding="utf-8")

        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
            dry_run=False,
        )
        current = detect_current_state(self.root)

        with self.assertRaises(FileExistsError):
            refactor_android(self.root, current, cfg)

    def test_clean_samples(self):
        # Create sample folders
        posts_dir = self.root / "lib" / "features" / "posts"
        catalog_dir = self.root / "lib" / "features" / "catalog"
        test_posts_dir = self.root / "test" / "features" / "posts"
        test_catalog_dir = self.root / "test" / "features" / "catalog"

        posts_dir.mkdir(parents=True)
        catalog_dir.mkdir(parents=True)
        test_posts_dir.mkdir(parents=True)
        test_catalog_dir.mkdir(parents=True)

        (posts_dir / "sample.dart").write_text("// sample", encoding="utf-8")
        (catalog_dir / "sample.dart").write_text("// sample", encoding="utf-8")

        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
            clean_samples=True,
            dry_run=False,
        )

        clean_sample_code(self.root, cfg)

        # Verify sample folders deleted
        self.assertFalse(posts_dir.exists())
        self.assertFalse(catalog_dir.exists())
        self.assertFalse(test_posts_dir.exists())
        self.assertFalse(test_catalog_dir.exists())

        # Verify HomeScreen created
        home_screen = self.root / "lib" / "features" / "home" / "presentation" / "home_screen.dart"
        self.assertTrue(home_screen.exists())
        home_content = home_screen.read_text(encoding="utf-8")
        self.assertIn("package:acme_shop/core/constants/app_constants.dart", home_content)
        self.assertIn("class HomeScreen extends ConsumerWidget", home_content)

        # Verify home_screen_test.dart created
        home_test = self.root / "test" / "features" / "home" / "home_screen_test.dart"
        self.assertTrue(home_test.exists())
        test_content = home_test.read_text(encoding="utf-8")
        self.assertIn("package:acme_shop/features/home/presentation/home_screen.dart", test_content)

        # Verify route_paths.dart
        route_paths = (self.root / "lib" / "core" / "routing" / "route_paths.dart").read_text(encoding="utf-8")
        self.assertIn("static const String home = '/';", route_paths)
        self.assertIn("static const String settings = '/settings';", route_paths)
        self.assertNotIn("catalog", route_paths)
        self.assertNotIn("posts", route_paths)

        # Auth paths must survive: settings_screen.dart is not a sample and it
        # navigates to RoutePaths.account, so dropping them would leave the
        # cleaned project unable to compile.
        self.assertIn("static const String login = '/login';", route_paths)
        self.assertIn("static const String splash = '/splash';", route_paths)
        self.assertIn("static const String account = '/account';", route_paths)

        # Verify app_router.dart. It lives under lib/app/, not lib/core/:
        # routing imports features, and core may not.
        stale_router = self.root / "lib" / "core" / "routing" / "app_router.dart"
        self.assertFalse(
            stale_router.exists(),
            "clean_sample_code must not resurrect the pre-move router path",
        )
        app_router = (self.root / "lib" / "app" / "routing" / "app_router.dart").read_text(encoding="utf-8")
        self.assertIn("initialLocation: RoutePaths.home", app_router)
        self.assertIn("builder: (context, state) => const HomeScreen()", app_router)
        self.assertNotIn("CatalogScreen", app_router)
        self.assertNotIn("PostsScreen", app_router)

        # Auth is infrastructure, not a sample: the cleaned router keeps the guard.
        self.assertIn("refreshListenable: authState", app_router)
        self.assertIn("authControllerProvider", app_router)
        self.assertIn("const LoginScreen()", app_router)
        self.assertIn("const SplashScreen()", app_router)
        self.assertIn("const AccountScreen()", app_router)

    def test_clean_samples_keeps_the_auth_slice(self):
        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
            clean_samples=True,
        )
        clean_sample_code(self.root, cfg)

        # Auth is infrastructure every new project needs on day one. Deleting it
        # with the posts/catalog samples would strip login, the route guard and
        # session persistence from every rebranded project.
        self.assertTrue((self.root / "lib" / "features" / "auth").is_dir())
        self.assertTrue((self.root / "test" / "features" / "auth").is_dir())

    def test_ios_display_name_escapes_xml(self):
        cfg = ProjectConfig(
            app_name="Acme & Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
        )
        current = detect_current_state(self.root)
        refactor_ios_and_macos(self.root, current, cfg)
        plistlib.loads((self.root / "ios" / "Runner" / "Info.plist").read_bytes())
        self.assertIn("Acme &amp; Shop", (self.root / "ios" / "Runner" / "Info.plist").read_text())

    def test_clean_samples_refuses_to_overwrite_existing_home_screen(self):
        home_screen = self.root / "lib" / "features" / "home" / "presentation" / "home_screen.dart"
        home_screen.parent.mkdir(parents=True)
        home_screen.write_text("// existing implementation", encoding="utf-8")
        cfg = ProjectConfig(
            app_name="Acme Shop",
            dart_name="acme_shop",
            bundle_id="com.acme.shop",
            clean_samples=True,
        )

        with self.assertRaises(FileExistsError):
            clean_sample_code(self.root, cfg)
        self.assertEqual(home_screen.read_text(encoding="utf-8"), "// existing implementation")


if __name__ == "__main__":
    unittest.main()
