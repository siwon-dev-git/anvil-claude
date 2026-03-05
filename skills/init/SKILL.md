---
name: init
trigger: anvil init|init anvil|setup anvil
description: Initialize .anvil/ governance in a project
---

# Init

First-time project setup. Creates `.anvil/` directory with governance files.

## Commands

- `/anvil init` — detect stack, create `.anvil/` with all governance files

## Flow

1. Run `scripts/detect-stack.sh` to identify package manager and tooling
2. Run `scripts/setup.sh` to scaffold `.anvil/` from templates
3. Report created files

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
└── checks/
    └── gates.yaml
```
