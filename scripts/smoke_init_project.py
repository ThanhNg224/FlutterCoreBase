#!/usr/bin/env python3
"""Check one real initializer scenario from a committed Git archive.

Default: rename/structure proof. --build adds real checks/builds in the same
throwaway clone. The source checkout, branch, index, and remote are never changed.
"""
from __future__ import annotations

import argparse
import hashlib
import subprocess
import sys
import tarfile
import tempfile
from io import BytesIO
from pathlib import Path


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def run(command: list[str], root: Path, env: dict[str, str] | None = None) -> None:
    print("RUN " + " ".join(command), flush=True)
    result = subprocess.run(command, cwd=root, env=env, capture_output=True, text=True)
    if result.returncode:
        detail = result.stdout[-4000:] + result.stderr[-1000:]
        raise RuntimeError(f"Command exited {result.returncode}: {' '.join(command)}\n{detail}")


def text(root: Path, path: str) -> str:
    return (root / path).read_text(encoding="utf-8")


def tree_digest(root: Path) -> str:
    digest = hashlib.sha256()
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root)
        if path.is_file() and ".git" not in relative.parts:
            digest.update(relative.as_posix().encode())
            digest.update(path.read_bytes())
    return digest.hexdigest()


def archive_revision(repo: Path, revision: str, clone: Path) -> None:
    result = subprocess.run(["git", "archive", "--format=tar", revision], cwd=repo, check=True, capture_output=True)
    with tarfile.open(fileobj=BytesIO(result.stdout), mode="r:") as bundle:
        bundle.extractall(clone, filter="data")


def check_clone(clone: Path, build: bool) -> None:
    command = [sys.executable, "-B", "scripts/init_project.py", "--app-name", "Smoke Flutter",
               "--dart-name", "smoke_flutter_app", "--bundle-id", "org.example.smokeflutter",
               "--clean-samples", "--skip-build-check", "--no-gitflow"]
    before = tree_digest(clone)
    run([*command, "--dry-run"], clone)
    require(tree_digest(clone) == before, "Dry-run changed archived source files")
    run(command, clone)
    require("name: smoke_flutter_app" in text(clone, "pubspec.yaml"), "Dart package was not renamed")
    require('applicationId = "org.example.smokeflutter"' in text(clone, "android/app/build.gradle.kts"), "Android app ID is stale")
    require("org.example.smokeflutter" in text(clone, "ios/Runner.xcodeproj/project.pbxproj"), "iOS bundle identity is stale")
    require((clone / "lib/features/home/presentation/home_screen.dart").is_file(), "Clean home shell is missing")
    require((clone / "lib/features/auth").is_dir(), "Auth slice was removed")
    for feature in ("posts", "catalog"):
        for folder in ("lib", "test"):
            require(not (clone / folder / "features" / feature).exists(), f"Sample {folder}/{feature} remains")
    for folder in ("lib", "test"):
        for path in (clone / folder).rglob("*.dart"):
            require("package:flutter_core_base/" not in path.read_text(), f"Old import in {path.relative_to(clone)}")
    if build:
        run(["make", "verify"], clone)
        run(["flutter", "build", "apk", "--debug", "--target-platform", "android-arm64"], clone)
        require((clone / "build/app/outputs/flutter-apk/app-debug.apk").is_file(), "Debug APK is missing")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--revision", default="HEAD")
    parser.add_argument("--build", action="store_true", help="Also verify/build the initialized temporary clone")
    args = parser.parse_args()
    try:
        with tempfile.TemporaryDirectory(prefix="fluttercorebase-init-smoke-") as temp:
            clone = Path(temp)
            archive_revision(args.repo.resolve(), args.revision, clone)
            check_clone(clone, args.build)
    except (OSError, RuntimeError, subprocess.CalledProcessError, tarfile.TarError) as error:
        print(f"FAIL initializer smoke: {error}", file=sys.stderr)
        return 1
    print("PASS archive initializer: rename" + (" + build/check" if args.build else " only (build skipped)"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
