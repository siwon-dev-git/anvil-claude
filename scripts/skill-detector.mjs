import { existsSync } from 'fs';
import { join } from 'path';

const root = process.cwd();
const anvilDir = join(root, '.anvil');

// Only activate if .anvil/ exists
if (!existsSync(anvilDir)) {
  console.log('Success');
  process.exit(0);
}

const input = process.env.CLAUDE_USER_PROMPT || '';
const lower = input.toLowerCase().trim();

const triggers = [
  { patterns: ['/anvil init', 'anvil init'], skill: 'anvil-claude:init' },
  { patterns: ['/constitution', 'constitution verify'], skill: 'anvil-claude:constitution' },
  { patterns: ['/self-model'], skill: 'anvil-claude:self-model' },
  { patterns: ['/adr'], skill: 'anvil-claude:adr' },
  { patterns: ['/fmea'], skill: 'anvil-claude:fmea' },
  { patterns: ['/gate-chain', '/gate chain'], skill: 'anvil-claude:gate-chain' },
  { patterns: ['/sprint'], skill: 'anvil-claude:sprint' },
  { patterns: ['/structure'], skill: 'anvil-claude:structure' },
  { patterns: ['/commit'], skill: 'anvil-claude:commit' },
  { patterns: ['/research'], skill: 'anvil-claude:research' },
  { patterns: ['/health'], skill: 'anvil-claude:health' },
];

for (const { patterns, skill } of triggers) {
  if (patterns.some(p => lower.startsWith(p))) {
    console.log(`[MAGIC KEYWORD: ${skill}]`);
    process.exit(0);
  }
}

console.log('Success');
