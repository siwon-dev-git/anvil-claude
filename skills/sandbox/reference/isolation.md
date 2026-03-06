# Isolation Model

## Why Git Worktrees

Anvil uses git worktrees for sandboxing because:

1. **Zero dependencies** — git is already present in every development environment
2. **Full fidelity** — worktree is a real checkout, not a simulation
3. **Parallel execution** — multiple worktrees can exist simultaneously
4. **Clean merge** — standard git merge/cherry-pick for applying changes
5. **Lightweight** — shares .git directory, minimal disk overhead

## Isolation Levels

```
Level 0: No isolation (current behavior)
  → Agent operates directly on working directory
  → Fast but risky

Level 1: Branch isolation (git worktree)
  → Agent works in separate worktree
  → Changes require explicit merge
  → Recommended for experimental tasks

Level 2: Environment isolation (future — container)
  → Full OS-level isolation
  → For untrusted operations
  → Not yet implemented
```

## Worktree Layout

```
project/
├── .git/               (shared)
├── src/                (main working tree)
├── .anvil/
│   ├── sandboxes/
│   │   ├── sandbox-001/    (worktree)
│   │   └── sandbox-002/    (worktree)
│   └── ...
```

## Governance in Sandboxes

- Constitution: read-only copy (cannot be modified in sandbox)
- Gate chain: runs independently
- FMEA/ADR: changes recorded but not merged until `apply`
- Traces: separate trace per sandbox

## Risk Model

| Risk | Mitigation |
|------|-----------|
| Uncommitted changes lost | Warn on destroy, require clean state |
| Merge conflicts | Run gate chain after merge to verify |
| Disk space accumulation | Auto-cleanup stale sandboxes (>24h) |
| Branch pollution | Use `anvil/sandbox/` prefix, auto-delete on destroy |
