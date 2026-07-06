#!/bin/bash
# install.sh — Copy goose-agents into place
#
# Usage: ./install.sh
# Run from the repo root after cloning.
#
# BEFORE RUNNING: Search for "/path/to/knowledge-base" in all YAML and
# SKILL.md files and replace it with your actual knowledge base path.
# For example:
#   sed -i 's|/path/to/knowledge-base|/home/you/Notes|g' agents/*.yaml recipes/*.yaml skills/knowledge-base/SKILL.md
#
# This script copies (not symlinks) the files into ~/.agents/ and
# ~/.config/goose/skills/. After editing repo files, re-run this
# script to update the installed copies.

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
  elif [ -L "$target" ]; then
    rm "$target"
    echo "  removed old symlink $target"
  fi
  cp "$f" "$target"
  echo "  copied agents/$name"
done

# --- Recipes ---
mkdir -p ~/.agents/recipes
for f in "$REPO_DIR"/recipes/*.yaml; do
  name="$(basename "$f")"
  target="$HOME/.agents/recipes/$name"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak"
    echo "  backed up existing $target → $target.bak"
  elif [ -L "$target" ]; then
    rm "$target"
    echo "  removed old symlink $target"
  fi
  cp "$f" "$target"
  echo "  copied recipes/$name"
done

# --- knowledge-base skill ---
mkdir -p ~/.config/goose/skills/knowledge-base
target="$HOME/.config/goose/skills/knowledge-base/SKILL.md"
if [ -f "$target" ] && [ ! -L "$target" ]; then
  mv "$target" "$target.bak"
  echo "  backed up existing $target → $target.bak"
elif [ -L "$target" ]; then
  rm "$target"
  echo "  removed old symlink $target"
fi
cp "$REPO_DIR/skills/knowledge-base/SKILL.md" "$target"
echo "  copied skills/knowledge-base/SKILL.md"

# --- agent-reach skill (no path substitution needed) ---
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
echo "Done. Files copied to ~/.agents/ and ~/.config/goose/skills/."
echo "The agent-reach skill uses symlinks (no paths to customize)."
echo ""
echo "NOTE: After editing repo files, re-run ./install.sh to update installed copies."
echo ""
echo "To verify: delegate(source: \"echo\") should work in Goose."
