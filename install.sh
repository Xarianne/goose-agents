#!/bin/bash
# install.sh — Symlink goose-agents repo into place
#
# Usage: ./install.sh
# Run from the repo root after cloning.
#
# Creates symlinks so edits in the repo take effect immediately.
# Existing files at the target paths will be backed up with a .bak suffix.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Installing goose-agents from $REPO_DIR"

# --- Agents ---
mkdir -p ~/.agents/agents
for f in "$REPO_DIR"/agents/*.yaml; do
  name="$(basename "$f")"
  target="$HOME/.agents/agents/$name"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak"
    echo "  backed up existing $target → $target.bak"
  fi
  ln -sf "$f" "$target"
  echo "  symlinked agents/$name"
done

# --- Recipes ---
mkdir -p ~/.agents/recipes
for f in "$REPO_DIR"/recipes/*.yaml; do
  name="$(basename "$f")"
  target="$HOME/.agents/recipes/$name"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak"
    echo "  backed up existing $target → $target.bak"
  fi
  ln -sf "$f" "$target"
  echo "  symlinked recipes/$name"
done

# --- knowledge-base skill ---
mkdir -p ~/.config/goose/skills/knowledge-base
target="$HOME/.config/goose/skills/knowledge-base/SKILL.md"
if [ -f "$target" ] && [ ! -L "$target" ]; then
  mv "$target" "$target.bak"
  echo "  backed up existing $target → $target.bak"
fi
ln -sf "$REPO_DIR/skills/knowledge-base/SKILL.md" "$target"
echo "  symlinked skills/knowledge-base/SKILL.md"

# --- agent-reach skill ---
mkdir -p ~/.agents/skills/agent-reach/references
for f in "$REPO_DIR"/skills/agent-reach/*.md; do
  name="$(basename "$f")"
  target="$HOME/.agents/skills/agent-reach/$name"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak"
    echo "  backed up existing $target → $target.bak"
  fi
  ln -sf "$f" "$target"
  echo "  symlinked skills/agent-reach/$name"
done
for f in "$REPO_DIR"/skills/agent-reach/references/*.md; do
  name="$(basename "$f")"
  target="$HOME/.agents/skills/agent-reach/references/$name"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak"
    echo "  backed up existing $target → $target.bak"
  fi
  ln -sf "$f" "$target"
  echo "  symlinked skills/agent-reach/references/$name"
done

echo ""
echo "✅ Done. All agents, recipes, and skills are symlinked."
echo "   Edits in $REPO_DIR take effect immediately."
echo ""
echo "   To verify: delegate(source: \"echo\") should work in Goose."
