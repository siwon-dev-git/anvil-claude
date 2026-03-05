# Maintain (Heal) Cycle

4-step SDEL: Sense → Decide → Execute → Learn

1. **Sense** — run `scripts/health-scan.sh`, collect lint/type/test status
2. **Decide** — prioritize by severity (failures > warnings > debt)
3. **Execute** — fix top issues, run gates after each fix
4. **Learn** — record new FMEA patterns, update self-model
