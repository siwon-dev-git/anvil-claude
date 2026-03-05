// PreToolUse:Bash — block dangerous patterns during sprint
const input = process.env.CLAUDE_TOOL_INPUT || '{}';

try {
  const parsed = JSON.parse(input);
  const cmd = parsed.command || '';

  const blocked = [
    { pattern: '--no-verify', reason: 'Anvil: --no-verify is prohibited. Fix the issue instead.' },
    { pattern: '--force', reason: 'Anvil: --force is prohibited. Use safe alternatives.' },
    { pattern: 'git push -f', reason: 'Anvil: force push is prohibited.' },
    { pattern: 'git reset --hard', reason: 'Anvil: hard reset is prohibited. Investigate first.' },
  ];

  for (const { pattern, reason } of blocked) {
    if (cmd.includes(pattern)) {
      console.log(reason);
      process.exit(0);
    }
  }
} catch {
  // parse error — allow
}

console.log('Success');
