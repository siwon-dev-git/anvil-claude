// PreToolUse:Edit/Write — warn on constitution.md modification
const input = process.env.CLAUDE_TOOL_INPUT || '{}';

try {
  const parsed = JSON.parse(input);
  const path = parsed.file_path || parsed.filePath || '';

  if (path.includes('.anvil/constitution.md')) {
    console.log('constitution.md is a trust anchor. Confirm this modification with the user before proceeding.');
  } else {
    console.log('Success');
  }
} catch {
  console.log('Success');
}
