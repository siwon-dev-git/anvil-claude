# anvil-claude

AI-native project governance plugin for Claude Code.

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

This creates the `.anvil/` directory with governance files. Then use skills like:

- `/anvil-claude:sprint <quest>` — Run a build cycle
- `/anvil-claude:adr` — Record an architecture decision
- `/anvil-claude:health` — Quick health scan
- `/anvil-claude:gate-chain` — Run quality gates

See [CLAUDE.md](./CLAUDE.md) for the full skill list.

## License

MIT
