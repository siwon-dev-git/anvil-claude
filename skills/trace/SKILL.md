---
name: trace
trigger: trace|inspect
description: Capture and inspect execution traces — what the agent actually did
---

# Trace

$ARGUMENTS

## Argument Parsing

- `start` -> Begin a new trace session
- `stop` -> End the active trace session, record results
- `inspect [run_id]` -> Read and summarize a trace record
- `list` -> List all traces in `.anvil/traces/`

## Commands

### `trace start`

Run: `bash scripts/trace-start.sh`

The script:
1. Ensures `.anvil/traces/` exists
2. Captures baseline: `git rev-parse HEAD`
3. Generates trace ID: `YYYY-MM-DD-HHMMSS`
4. Creates trace file from template
5. Writes trace file path to `.anvil/traces/.active`

### `trace stop`

Run: `bash scripts/trace-stop.sh`

The script:
1. Reads `.anvil/traces/.active` to find active trace
2. Captures end state: `git diff`, `git log`, commit count
3. Writes results into the trace file
4. Updates status to `completed`, removes `.active` marker

### `trace inspect [run_id]`

1. If `run_id` provided, read `.anvil/traces/<run_id>.md`
2. If no `run_id`, read the most recent trace file (by filename sort)
3. Summarize: quest, duration, files changed, gate results, key decisions

### `trace list`

1. List all `.md` files in `.anvil/traces/` (excluding `.active`)
2. Show: trace ID, date, one-line summary

## Format

See `reference/format.md` for the trace record format specification.
