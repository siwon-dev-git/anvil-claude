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

1. Ensure `.anvil/traces/` exists (`mkdir -p`)
2. Capture baseline: `git rev-parse HEAD` -> store as `baseline_commit`
3. Generate trace ID: `YYYY-MM-DD-HHMMSS` (from `date +%Y-%m-%d-%H%M%S`)
4. Create trace file from `templates/trace-log.md` at `.anvil/traces/<trace_id>.md`
5. Fill in: trace ID, baseline commit, start timestamp
6. Write trace file path to `.anvil/traces/.active`
7. Report: "Trace started: <trace_id>"

### `trace stop`

1. Read `.anvil/traces/.active` to find active trace file
2. If no active trace, report error and exit
3. Capture end state:
   - `git rev-parse HEAD` -> end commit
   - `git diff <baseline>..HEAD --stat` -> changed files summary
   - `git log <baseline>..HEAD --oneline` -> commit log
4. Append results to the trace file (## Results section)
5. Delete `.anvil/traces/.active`
6. Report: "Trace stopped: <trace_id> — N files changed, M commits"

### `trace inspect [run_id]`

1. If `run_id` provided, read `.anvil/traces/<run_id>.md`
2. If no `run_id`, read the most recent trace file (by filename sort)
3. Summarize: quest, duration, files changed, gate results, key decisions

### `trace list`

1. List all `.md` files in `.anvil/traces/` (excluding `.active`)
2. Show: trace ID, date, one-line summary

## Format

See `reference/format.md` for the trace record format specification.
