---
name: sandbox
trigger: sandbox|isolate
description: Isolated execution environment for safe agent experimentation
---

# Sandbox

Run agent tasks in isolated environments to prevent unintended side effects.

$ARGUMENTS

## Argument Parsing

- `create [name]` -> Create a new sandbox (git worktree)
- `destroy [name]` -> Clean up a sandbox
- `list` -> List active sandboxes
- `apply [name]` -> Merge sandbox changes back to main worktree

## Status

**Phase 4 — structural foundation only.** Full implementation depends on data from Phase 1-3.

## Flow

### `sandbox create [name]`

1. Generate sandbox name if not provided: `sandbox-<timestamp>`
2. Create git worktree: `git worktree add .anvil/sandboxes/<name> -b anvil/sandbox/<name>`
3. Copy `.anvil/` governance files into the sandbox
4. Report: "Sandbox ready: <name> at .anvil/sandboxes/<name>"
5. Agent operates within the sandbox directory

### `sandbox destroy [name]`

1. Verify sandbox exists
2. Check for uncommitted changes — warn if present
3. Remove worktree: `git worktree remove .anvil/sandboxes/<name>`
4. Delete branch: `git branch -d anvil/sandbox/<name>`

### `sandbox apply [name]`

1. Verify all changes in sandbox are committed
2. Run gate chain in sandbox to verify quality
3. Cherry-pick or merge commits into current branch
4. Destroy sandbox after successful apply

## Design Principles

- Sandbox = git worktree (no containers, no VMs — portable)
- Governance files are inherited but isolated
- Gate chain runs independently in sandbox
- Changes only escape sandbox via explicit `apply`

## Integration with OMC

When integrated with OMC's Team/Autopilot:
- Each agent gets its own sandbox
- Parallel sandboxes for parallel agents
- Merge conflicts resolved at apply time

## Reference

See `reference/isolation.md` for isolation model details.
