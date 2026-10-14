#!/usr/bin/env bash
# Installs the working agreement, skills, agents, hook and settings into ~/.claude (Linux/macOS).
# Existing files are backed up with a timestamp before being replaced. Run from the repository root.
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="${HOME}/.claude"
stamp="$(date +%Y%m%d-%H%M%S)"

install_item() {
  local from="$1" to="$2"
  if [ -e "$to" ]; then
    mv "$to" "$to.bak-$stamp"
    echo "backed up $to -> $to.bak-$stamp"
  fi
  mkdir -p "$(dirname "$to")"
  cp -R "$from" "$to"
  echo "installed $to"
}

install_item "$source_dir/CLAUDE.md"              "$target_dir/CLAUDE.md"
install_item "$source_dir/settings.template.json" "$target_dir/settings.json"
install_item "$source_dir/hooks"                  "$target_dir/hooks"

for skill in "$source_dir"/skills/*/; do
  install_item "$skill" "$target_dir/skills/$(basename "$skill")"
done
for agent in "$source_dir"/agents/*.md; do
  install_item "$agent" "$target_dir/agents/$(basename "$agent")"
done

chmod +x "$target_dir/hooks/no-ai-attribution.js" || true
command -v node >/dev/null || echo "warning: node not found on PATH; the no-ai-attribution hook needs Node.js."

echo
echo "Done. Open a new session for the settings and hook to take effect."
