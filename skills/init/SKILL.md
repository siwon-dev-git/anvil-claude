---
name: init
trigger: anvil init|init anvil|setup anvil
description: Initialize .anvil/ governance in a project
---

# Init

First-time project setup. Creates `.anvil/` directory with governance files.

## Commands

- `/anvil-claude:init` — detect stack, create `.anvil/` with all governance files

## Flow

1. Run `skills/init/scripts/detect-stack.sh` to identify package manager and tooling
2. Run `skills/init/scripts/setup.sh` to scaffold `.anvil/` from templates
3. Report created files and next steps
4. Ask the user 3 questions to fill constitution:
   a. "What is this project's ultimate goal (Terminal Goal)?" — e.g. "Build the fastest static site generator", "Provide reliable payment processing" → ## Terminal Goal
   b. "What rules must never be violated (Hard Constraints)?" — give 3 examples: "No direct DB access from UI layer", "All API changes must be backward-compatible", "Never store plaintext passwords" → ## Hard Constraints
   c. "What principles should be followed when possible (Soft Constraints)?" — e.g. "Prefer composition over inheritance", "Keep functions under 30 lines", "Write tests before implementation" → ## Soft Constraints
5. Write answers into `.anvil/constitution.md` (replace HTML comments with actual content)
6. Generate checksum: `shasum -a 256 .anvil/constitution.md > .anvil/.constitution.sha256`

## What gets created

```
.anvil/
├── profile.yaml         <- stack config (from detection)
├── constitution.md      <- trust anchor (from template)
├── self-model.md        <- project identity (from template)
├── decisions/
│   ├── active.md
│   └── archived.md
├── failures/
│   ├── active.md
│   └── archived.md
├── structure/
│   └── tiers.md
├── checks/
│   └── gates.yaml
└── traces/              <- execution trace storage
```
