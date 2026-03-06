---
name: replay
trigger: replay|reproduce
description: Reproduce past agent executions from trace data
---

# Replay

Reproduce and analyze past agent executions using trace records.

$ARGUMENTS

## Argument Parsing

- `show <trace_id>` -> Display execution replay timeline
- `diff <trace_id>` -> Show the complete diff from a trace
- `compare <id1> <id2>` -> Compare two trace executions
- `failing` -> List traces that ended with gate failures

## Status

**Phase 4 — structural foundation only.** Full deterministic replay depends on runtime infrastructure from Phase 3+.

## Flow

### `replay show <trace_id>`

1. Read `.anvil/traces/<trace_id>.md`
2. Reconstruct execution timeline:
   - Baseline commit → changes → gate results → end commit
3. Display step-by-step: what happened, in what order
4. Highlight: failures, retries, fixes applied

### `replay diff <trace_id>`

1. Read trace to extract baseline and end commits
2. Run `git diff <baseline>..<end>` for full diff
3. Annotate diff with trace activity log entries
4. Show: which changes were intentional vs. fix-ups

### `replay compare <id1> <id2>`

1. Read both traces
2. Compare:
   - Quest/goal
   - Files touched
   - Gate results
   - Duration
   - Failure patterns
3. Highlight differences: what went differently and why

### `replay failing`

1. Scan all traces in `.anvil/traces/`
2. Filter for traces with gate failures in the Gates table
3. Group by failure category
4. Show: which patterns keep causing problems

## Future: Deterministic Replay

Full deterministic replay would require:

1. **Input capture** — all LLM prompts and responses logged
2. **Tool call recording** — exact tool calls with parameters
3. **Environment snapshot** — dependencies, env vars, OS state
4. **Replay engine** — execute recorded actions in sequence

This is **technically challenging** and deferred until Phase 1-3 data shows clear demand. Current approach (trace-based reconstruction) provides 80% of the value at 20% of the complexity.

## Reference

See `reference/replay-model.md` for technical analysis.
