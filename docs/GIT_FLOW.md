# GIT_FLOW.md

## Git & Collaboration Workflow

### 1. Branching Strategy
- `main` / `master`: Production-ready, stable codebase.
- `develop`: Integration branch for ongoing development.
- `feature/<feature-name>`: Dedicated branch for specific features or refactor tasks.
- `bugfix/<issue-name>`: Dedicated branch for resolving bugs.

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
3. **Pre-commit Verification:** Always ensure `flutter analyze` and `flutter test` pass before committing.
