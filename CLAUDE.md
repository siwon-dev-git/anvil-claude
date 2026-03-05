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
| `/constitution` | "constitution", "rules" | Trust anchor management |
| `/self-model` | "self-model", "status" | Project self-awareness |
| `/adr` | "adr", "decision" | Architecture Decision Records |
| `/fmea` | "fmea", "failure" | Failure Mode & Effects Analysis |
| `/gate-chain` | "gate", "check" | Sequential quality gates |
| `/sprint <quest>` | "sprint", "build" | Build cycle (11 steps + 6 gates) |
| `/sprint [N]` | "maintain", "heal" | Heal cycle (sense-decide-execute-learn) |
| `/structure` | "structure", "tier" | Code structure classification |
| `/commit` | "commit" | Commit convention + PR workflow |
| `/research` | "research" | Evidence-based research with falsification |
| `/health` | "health" | Quick health scan |
| `/anvil init` | first-time setup | Project initialization |

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
│   └── *.sh             <- Gate scripts (exit 0/1)
└── profile.yaml         <- Project configuration
```

## Gate Execution

Run gate scripts with `bash` and judge by exit code only.
The agent's role is "execute + fix on failure", NOT "judge pass/fail".
