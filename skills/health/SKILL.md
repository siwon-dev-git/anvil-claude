---
name: health
trigger: health|scan|check
description: Quick project health scan
---

# Health

Quick diagnostic scan. Runs `scripts/scan.sh` and reports status.

## Commands

- `/health` — run full scan (lint + types + tests + budget + git status)
- Output: pass/fail per category with issue count
