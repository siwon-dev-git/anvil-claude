# Research Routine

## Step 1: Question
- Write the question in one sentence
- Identify what "answered" looks like

## Step 2: Hypothesis
- State a falsifiable prediction
- Bad: "React is good" / Good: "React re-renders cause the 200ms lag"

## Step 3: Evidence
- Search codebase (grep, symbols, call graph)
- Read documentation
- Run targeted experiments (scripts, benchmarks)
- Cite sources for each finding

## Step 4: Falsify
- Ask: "What would disprove this?"
- Run the disproving experiment
- If disproved, form new hypothesis and loop

## Step 5: Conclude
- State finding with confidence: high (proven+falsified) / medium (evidence supports) / low (inconclusive)
- Record in ADR if architectural, in FMEA if failure-related
