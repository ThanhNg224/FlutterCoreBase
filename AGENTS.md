# AGENTS.md

## Mission

This document defines how AI assistants and developers should contribute to this Flutter starter project. Contributions must prioritize maintainability, consistency, strict adherence to Feature-First Clean Architecture, Riverpod best practices, and long-term code quality.

---

## Engineering Documents

This repository is governed by multiple engineering documents located in `docs/`. Every implementation must follow all relevant documents instead of relying on assumptions.

| Document                       | Responsibility                                                                                                                    |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| **`docs/AGENTS.md`**           | AI workflow, engineering mindset, implementation strategy, decision making, and review process.                                  |
| **`docs/ARCHITECTURE.md`**     | Feature-First Clean Architecture, Riverpod Generator patterns, dependency boundaries, data flow, and native bridge integration. |
| **`docs/STANDARD.md`**         | Dart & Flutter coding conventions, formatting, widget design, naming rules, and code quality.                                     |
| **`docs/CORE_MODULES.md`**     | Core infrastructure (Theme, Network, Storage, Routing, Constants, Reusable Widgets).                                              |
| **`docs/FEATURE_TEMPLATE.md`** | Step-by-step guide and template structure for developing new feature modules.                                                    |
| **`docs/GIT_FLOW.md`**         | Branching strategy, commit conventions, and collaboration rules.                                                                  |

Treat these documents as the project's engineering source of truth.

---

## Core Engineering Principles

- **Understand before implementing:** Read existing code and relevant docs first.
- **Reuse before creating:** Check `core/` and existing features before introducing new components.
- **Consistency over perfection:** Follow project patterns strictly.
- **Simplicity over cleverness:** Write self-explanatory code over overly concise tricks.
- **Separation of Concerns:** Keep UI widgets dumb; state in Riverpod notifiers; business logic in domain; platform/remote in data.

---

## AI Workflow

For every request:
1. Understand the user's intent and business context.
2. Identify which engineering documents apply.
3. Explore existing implementations and search for similar patterns.
4. Implement the smallest complete and working solution.
5. Run `flutter analyze` and `flutter test` to ensure zero regressions.
6. Perform a thorough self-review before presenting results.

---

## Git & Commit Rules

- **No Co-author:** Never include co-author metadata (`Co-authored-by: ...`) in any commit message.
- **Logical Commits:** Keep commits focused on a single logical change.
