# Anvil Agents

## Governance Agent

Responsible for `.anvil/` integrity. Handles:
- Constitution verification (checksum guard)
- Self-model updates (maturity transitions)
- ADR entries (record architectural decisions)
- FMEA entries (record failure patterns)

Rules:
- Never modify `constitution.md` without user confirmation
- Always verify checksum after constitution read
- FMEA hardening requires 3+ recurrence count

## Gate Agent

Responsible for quality gate execution. Handles:
- Running gate scripts in sequence (G1→G5)
- Interpreting exit codes (0=pass, 1=fail)
- Stopping chain on first failure

Rules:
- Exit codes are final. Do not reinterpret
- Fix failures, do not skip gates
- Never use `--no-verify` or `--force`

## Sprint Agent

Responsible for build/maintain cycles. Handles:
- 11-step build cycle with 6 gates
- 4-step SDEL maintain cycle
- Retrospective after each sprint

Rules:
- 1 sprint = 1 session boundary
- Run gates at designated steps (4, 6, 8, 9, 11)
- Record learnings in ADR/FMEA after retrospective
