# Gate Chain Configuration
# Customize gates for your project

chain:
  - id: G0
    name: scope
    type: manual
    description: "Scope declaration + FMEA cross-reference"

  - id: G1
    name: surface
    type: script
    run: surface.sh
    auto_fix: true
    retry: 1

  - id: G2
    name: static
    type: script
    run: static.sh
    retry: 3

  - id: G3
    name: runtime
    type: script
    run: runtime.sh
    retry: 3

  - id: G3+
    name: budget
    type: script
    run: budget.sh
    retry: 0

  - id: G4
    name: retro
    type: manual
    description: "Update decisions + failures if 3+ commits since last retro"

  - id: G5
    name: ci
    type: script
    run: ci.sh
    retry: 3
