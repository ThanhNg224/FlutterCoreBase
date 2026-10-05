# GIT_FLOW.md

## Git & Collaboration Workflow

### 1. Branching Strategy

> **Lưu ý về Repository Base Template (Giai đoạn Solo Maintainer):**
> - Đối với repo base template này, mọi thay đổi được phát triển trực tiếp trên nhánh `main` để tinh gọn workflow và tránh phức tạp hóa việc bảo trì.
> - Khi dự án được khởi tạo thành dự án thực tế qua `scripts/init_project.py` (hoặc `make init`), dự án sẽ vận hành đầy đủ theo mô hình GitFlow dưới đây.

- `main`: Production-ready, stable codebase.
- `develop`: Integration branch for ongoing development.
- `feature/<feature-name>`: Dedicated branch for specific features or refactor tasks.
- `bugfix/<issue-name>`: Dedicated branch for resolving bugs.
- `release/<version>`: Release preparation and staging.
- `hotfix/<issue-name>`: Emergency production bug fixes.

---

### 2. Commit Message Standards

Use Conventional Commits format:
```text
<type>(<scope>): <short description>
```

#### Allowed Types:
- `feat`: A new feature or screen.
- `fix`: A bug fix.
- `refactor`: Code restructuring without changing behavior.
- `chore`: Tooling, dependencies, or configuration changes.
- `docs`: Documentation updates.
- `test`: Adding or modifying tests.

#### Examples:
- `feat(catalog): implement capability grid`
- `refactor(core): update AppColors and contrast thresholds`
- `docs: add architecture and engineering rules`

---

### 3. Strict Rules

1. **NO Co-author Metadata:** Never append co-author signatures (`Co-authored-by: ...`) to commit messages.
2. **Logical Atomic Commits:** Group related changes together logically; avoid unorganized blobs.
3. **Pre-commit Verification:** Use the applicable risk level and commands in [Verification](VERIFICATION.md) before committing.
4. **Disk Hygiene:** `make setup` installs a `pre-push` hook (`.githooks/pre-push`) that auto-runs `flutter clean` once `build/` + `.dart_tool/` exceed 2GiB, so local build caches don't grow unbounded. Run `make hooks-install` manually if you skipped `make setup`.
