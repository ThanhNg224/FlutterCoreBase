# Documentation editing rules

- The root [`AGENTS.md`](../AGENTS.md) owns workflow and repository-wide rules.
- Keep each engineering rule in its owning document: `ARCHITECTURE.md` for layers, Riverpod patterns, and data flow; `STANDARD.md` for coding conventions, design system, and quality contracts; `CORE_MODULES.md` for reusable components; `FEATURE_TEMPLATE.md` for feature structure; and `GIT_FLOW.md` for branching and releases.
- Do not copy the same requirement into multiple documents. Link to its source when another document needs to refer to it.
- Keep plans and execution notes clearly historical; do not treat them as current policy when they differ from the owning document.
- For documentation-only edits, check the diff, internal links, and affected claims. Do not run unrelated build or test gates.
