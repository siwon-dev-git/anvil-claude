# Anvil

AI-native project governance. Skills = words, Scripts = code.

## Axioms

1. **Environment is intelligence** — the quality of the substrate determines the capability of the agent
2. **Design physics, not control** — design environments, not commands
3. **Success is becoming unnecessary** — as trust accumulates, intervention decreases

## Hard Constraints

1. `.anvil/constitution.md` modification requires explicit user confirmation
2. Gate script exit codes are final. exit 0 = PASS, exit 1 = FAIL. No reinterpretation
3. `--no-verify`, `--force` usage prohibited
4. 1 sprint cycle = 1 session. Do not violate session boundary
5. Never auto-merge. Merge is the user's decision

## Soft Constraints

A. Broad benefit — pursue universal good
B. Golden rule — write code as you would want to receive it

## Constraint Priority

User direct instruction > Hard Constraints > Soft Constraints > Project constitution > Execution logic

## Skills

Available when `.anvil/` exists in the project root.

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `/anvil-claude:init` | "anvil init" | Project initialization |
| `/anvil-claude:constitution` | "constitution", "rules" | Trust anchor management |
| `/anvil-claude:self-model` | "self-model", "status" | Project self-awareness |
| `/anvil-claude:adr` | "adr", "decision" | Architecture Decision Records |
| `/anvil-claude:fmea` | "fmea", "failure" | Failure Mode & Effects Analysis |
| `/anvil-claude:gate-chain` | "gate", "check" | Sequential quality gates |
| `/anvil-claude:sprint <quest>` | "sprint", "build" | Build cycle (11 steps + 6 gates) |
| `/anvil-claude:sprint` | "maintain", "heal" | Heal cycle (sense-decide-execute-learn) |
| `/anvil-claude:structure` | "structure", "tier" | Code structure classification |
| `/anvil-claude:commit` | "commit" | Commit convention + PR workflow |
| `/anvil-claude:research` | "research" | Evidence-based research with falsification |
| `/anvil-claude:health` | "health" | Quick health scan |
| `/anvil-claude:trace` | "trace", "inspect" | Execution trace capture |
| `/anvil-claude:insight` | "insight", "explain", "why" | Failure analysis |
| `/anvil-claude:pattern` | "pattern", "learn", "cluster" | Failure pattern detection |
| `/anvil-claude:guard` | "guard", "enforce", "protect" | Adaptive runtime guardrails |
| `/anvil-claude:sandbox` | "sandbox", "isolate" | Isolated execution environment |
| `/anvil-claude:replay` | "replay", "reproduce" | Execution replay & comparison |

## How It Works

```
User prompt → skill-detector.sh → matches trigger → SKILL.md loaded as context
SessionStart → session-context.sh → injects .anvil/ state
PreToolUse:Bash → gate-guard.sh → blocks --force/--no-verify
PreToolUse:Edit/Write → constitution-guard.sh → warns on constitution.md
PostToolUse:Edit/Write → diagnostic-reminder.sh → check IDE diagnostics
```

## Governance Files

```
.anvil/
├── constitution.md      <- Trust anchor (user-only modification)
├── self-model.md        <- Mutable project identity
├── decisions/
│   ├── active.md        <- Living ADR entries
│   └── archived.md      <- Resolved/superseded decisions
├── failures/
│   ├── active.md        <- Living FMEA patterns
│   └── archived.md      <- Hardened (defended) patterns
├── structure/
│   └── tiers.md         <- Tier classification rules
├── checks/
│   ├── gates.yaml       <- Gate definitions
│   ├── guards.md        <- Adaptive guard rules
│   └── *.sh             <- Gate scripts (exit 0/1)
├── traces/              <- Execution trace records
├── sandboxes/           <- Isolated worktrees (Phase 4)
└── profile.yaml         <- Project configuration (stack, commands)
```

## profile.yaml

Stack detection auto-generates this. Override tool commands here:

```yaml
stack: node
pkg: pnpm
commands:
  lint: pnpm run lint
  typecheck: pnpm run typecheck
  test: pnpm run test:ci
  build: pnpm run build
  format_check: pnpm run format:check
  format: pnpm run format
```

## Gate Execution

Run gate scripts with `bash` and judge by exit code only.
The agent's role is "execute + fix on failure", NOT "judge pass/fail".
