# Anvil

**Execution Intelligence for AI Agents**

AI agents can generate code.
But they can't explain why your build just broke.
Anvil can.

## What It Does

- **Constitution** — Immutable trust anchor. Rules only humans can change
- **Gate Chain** — Script-based quality gates. Exit code = verdict
- **Heritage** — ADR + FMEA. Your project remembers decisions and failures
- **Trace** — Capture what the agent actually did
- **Insight** — Explain why things broke
- **Pattern** — Compress recurring failures into rules
- **Guard** — Learned rules applied at runtime
- **Sandbox** — Isolated execution environments
- **Replay** — Reproduce and compare past executions

## The Core Loop

```
run → observe → understand → improve → run
```

## Install

```bash
claude plugin add anvil-claude
```

## Quick Start

```
/anvil-claude:init
```

This creates the `.anvil/` directory with governance files, then guides you through setting up your project's constitution.

## Skills

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
| Trace | `/anvil-claude:trace` | Execution trace capture |
| Insight | `/anvil-claude:insight` | Failure analysis |
| Pattern | `/anvil-claude:pattern` | Failure pattern detection |
| Guard | `/anvil-claude:guard` | Adaptive runtime guardrails |
| Sandbox | `/anvil-claude:sandbox` | Isolated execution |
| Replay | `/anvil-claude:replay` | Execution replay |

## How It Works

```
User input → skill-detector.sh → matches trigger → loads SKILL.md as context
                                                  → agent follows skill instructions
```

1. **Hooks** (`hooks/hooks.json`) — run on session start, user prompt, and tool use
2. **Scripts** (`scripts/*.sh`) — detect triggers, inject context, guard constraints
3. **Skills** (`skills/*/SKILL.md`) — instructions the AI follows for each capability
4. **Gate scripts** (`skills/*/scripts/*.sh`) — executable checks with exit 0/1

## Philosophy

1. **Environment is intelligence** — the quality of the substrate determines the capability of the agent
2. **Design physics, not control** — design environments, not commands
3. **Success is becoming unnecessary** — as trust accumulates, intervention decreases

## License

MIT
