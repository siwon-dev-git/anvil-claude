import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

const root = process.cwd();
const anvilDir = join(root, '.anvil');

if (!existsSync(anvilDir)) {
  console.log('Success');
  process.exit(0);
}

const parts = [];

// Project status
if (existsSync(join(anvilDir, 'self-model.md'))) {
  const model = readFileSync(join(anvilDir, 'self-model.md'), 'utf-8');
  const stateMatch = model.match(/## Current State[\s\S]*?(?=\n## |$)/);
  if (stateMatch) {
    const lines = stateMatch[0].split('\n').slice(1, 6).join('\n').trim();
    if (lines) parts.push(`[Anvil] ${lines}`);
  }
}

// Active failure pattern count
if (existsSync(join(anvilDir, 'failures/active.md'))) {
  const failures = readFileSync(join(anvilDir, 'failures/active.md'), 'utf-8');
  const count = (failures.match(/^- \*\*/gm) || []).length;
  if (count > 0) parts.push(`Active failure patterns: ${count}`);
}

// Active decision count
if (existsSync(join(anvilDir, 'decisions/active.md'))) {
  const decisions = readFileSync(join(anvilDir, 'decisions/active.md'), 'utf-8');
  const count = (decisions.match(/^- \*\*/gm) || []).length;
  if (count > 0) parts.push(`Active decisions: ${count}`);
}

// Current gate state
if (existsSync(join(anvilDir, 'checks/.current-gate'))) {
  const gate = readFileSync(join(anvilDir, 'checks/.current-gate'), 'utf-8').trim();
  parts.push(`Current gate: ${gate}`);
}

if (parts.length > 0) {
  console.log(parts.join('\n'));
} else {
  console.log('Success');
}
