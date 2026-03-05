# anvil-claude

AI-native project governance plugin for Claude Code.

AI coding assistants are powerful but lack structured quality assurance. Anvil adds governance guardrails — constitution, quality gates, failure tracking, architecture decisions — so AI-assisted development produces reliable, auditable results.

## Features

- **Constitution** — Immutable trust anchor. Hard constraints only the human owner may modify
- **Self-Model** — Mutable project identity reflecting current capabilities and state
- **ADR** — Architecture Decision Records with rationale tracking
- **FMEA** — Failure Mode & Effects Analysis to prevent recurrence
- **Gate Chain** — Sequential quality gates with script-based pass/fail
- **Sprint** — Build cycle (11 steps + 6 gates) and Heal cycle
- **Structure** — Code structure classification and audit (Tier 0-3)
- **Commit** — Commit convention enforcement and PR workflow
- **Research** — Evidence-based research with falsification
- **Health** — Quick project health scan

## Install

```bash
claude plugin add anvil-claude
```

## Usage

After installing, initialize governance in your project:

```
/anvil-claude:init
```

This creates the `.anvil/` directory with governance files. Then use skills:

| Skill | Command | Purpose |
|-------|---------|---------|
| Init | `/anvil-claude:init` | First-time project setup |
| Constitution | `/anvil-claude:constitution` | View/verify trust anchor |
| Self-Model | `/anvil-claude:self-model` | Project identity and state |
| ADR | `/anvil-claude:adr` | Record architecture decisions |
| FMEA | `/anvil-claude:fmea` | Record failure patterns |
| Gate Chain | `/anvil-claude:gate-chain` | Run quality gates |
| Sprint | `/anvil-claude:sprint <quest>` | Build cycle |
| Sprint | `/anvil-claude:sprint` | Heal/maintain cycle |
| Structure | `/anvil-claude:structure` | Code tier classification |
| Commit | `/anvil-claude:commit` | Commit with conventions |
| Research | `/anvil-claude:research` | Evidence-based research |
| Health | `/anvil-claude:health` | Quick project scan |

## How It Works

```
User input → skill-detector.sh → matches trigger → loads SKILL.md as context
                                                  → agent follows skill instructions
```

1. **Hooks** (`hooks/hooks.json`) — run on session start, user prompt, and tool use
2. **Scripts** (`scripts/*.sh`) — detect triggers, inject context, guard constraints
3. **Skills** (`skills/*/SKILL.md`) — instructions the AI follows for each capability
4. **Gate scripts** (`skills/*/scripts/*.sh`) — executable checks with exit 0/1

## License

MIT
