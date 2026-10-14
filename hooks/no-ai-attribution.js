#!/usr/bin/env node
// PreToolUse hook for Bash: blocks git commits, amends and PR creations whose message
// attributes the work to an assistant, a model or "AI", or carries a Co-Authored-By trailer.
// Exit code 2 rejects the tool call and sends the reason back as feedback.

const fs = require("node:fs");

let input = "";
try {
  input = fs.readFileSync(0, "utf8");
} catch {
  process.exit(0);
}

let command = "";
try {
  const payload = JSON.parse(input);
  command = String(payload?.tool_input?.command ?? "");
} catch {
  process.exit(0);
}

const touchesHistory = /\bgit\s+(commit|merge|tag|notes)\b|\bgh\s+pr\s+(create|edit)\b|\bglab\s+mr\s+(create|update)\b/i.test(command);
if (!touchesHistory) {
  process.exit(0);
}

const forbidden = [
  /co-authored-by\s*:/i,
  /generated\s+(with|by)\s+/i,
  /\bclaude\b/i,
  /\banthropic\b/i,
  /\bcopilot\b/i,
  /\bchatgpt\b|\bopenai\b|\bgpt-?\d/i,
  /\b(an?\s+)?(ai|llm)\b.*\b(assist|generat|wrote|written|help)/i,
  /\bnoreply@anthropic\.com\b/i,
];

const hit = forbidden.find((pattern) => pattern.test(command));
if (hit) {
  process.stderr.write(
    "Blocked: commit/PR text must not mention an assistant, a model or AI, and must not carry " +
      "Co-Authored-By trailers. Rewrite the message as a plain conventional commit (pattern: " +
      String(hit) +
      ").\n",
  );
  process.exit(2);
}

process.exit(0);
