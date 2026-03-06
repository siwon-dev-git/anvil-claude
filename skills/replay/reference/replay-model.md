# Replay Model

## Current Approach: Trace-Based Reconstruction

```
Trace record → git history → diff reconstruction → timeline display
```

This is not true deterministic replay — it's **post-hoc reconstruction** from:
- Git commits (what changed)
- Trace activity log (what happened)
- Gate results (what passed/failed)

Advantage: Works with zero additional infrastructure.
Limitation: Cannot reproduce the exact LLM reasoning or intermediate states.

## Future: Deterministic Replay

### Requirements

1. **Capture layer** — Record all agent actions:
   - LLM API calls (prompt + response)
   - Tool use (tool name + parameters + result)
   - File system operations (read/write/delete)
   - Shell commands (command + output + exit code)

2. **Storage** — Structured trace format:
   ```json
   {
     "id": "run_142",
     "actions": [
       {"type": "llm_call", "prompt": "...", "response": "...", "tokens": 1234},
       {"type": "tool_use", "tool": "Edit", "params": {...}, "result": "..."},
       {"type": "shell", "cmd": "npm test", "exit_code": 1, "output": "..."}
     ]
   }
   ```

3. **Replay engine** — Execute recorded actions:
   - Restore environment to baseline state
   - Feed recorded prompts to LLM (or mock responses)
   - Verify tool outputs match recorded results
   - Detect divergence points

### Technical Challenges

| Challenge | Difficulty | Notes |
|-----------|:----------:|-------|
| LLM response non-determinism | High | Same prompt ≠ same response. Need response mocking |
| Environment drift | Medium | Package versions, OS updates between record/replay |
| External API changes | High | Third-party APIs may behave differently |
| Storage volume | Medium | Full traces can be large (MB per run) |
| Privacy/security | High | Traces may contain sensitive data |

### Feasibility Assessment

True deterministic replay is technically possible but complex. The trace-based reconstruction approach is recommended until:
1. Clear user demand for full replay exists
2. Phase 1-3 data reveals specific replay use cases
3. Storage and privacy concerns are addressed

### Hybrid Approach (Recommended)

Combine trace reconstruction with selective recording:
- Always: git diff + gate results + activity timeline
- Optional: tool call parameters (for debugging specific failures)
- Never (by default): full LLM conversations (privacy risk)
