# goose-agents

Personal Goose agent definitions — recipes, agents, and skills for the [Goose](https://github.com/block/goose) AI agent framework.

## What's here

```
goose-agents/
├── agents/               # Agent definitions (discoverable via delegate)
│   ├── echo.yaml         #   Learning agent — captures experiences, consolidates judgment
│   ├── knowledge-curator.yaml  # KB writer — frontmatter, citations, log discipline
│   └── search.yaml       # Web research — SearXNG + Tavily
├── recipes/              # Recipe definitions (same content, alternate discovery path)
│   ├── echo.yaml
│   ├── knowledge-curator.yaml
│   └── search.yaml
├── skills/               # Goose skills
│   ├── knowledge-base/   #   Shell-based KB search (replaces Hindsight/OpenKnowledge MCP)
│   │   └── SKILL.md
│   └── agent-reach/      #   Platform-specific search — supplement for search agent
│       ├── SKILL.md
│       └── references/   #   Twitter/X, Reddit, XiaoHongShu, GitHub, YouTube, etc.
├── install.sh            # Symlinks everything into place
├── .gitignore
└── README.md
```

## Agents

| Agent | What it does | When to use |
|-------|-------------|-------------|
| **Echo** | Captures agent experiences, consolidates into compact judgment, reflects on past lessons | Session start (recall), session end (retain), weekly (consolidate) |
| **Knowledge Curator** | Writes/edits KB docs with proper frontmatter, citations, linking, log discipline | Any KB write or restructure |
| **Search** | Web research via SearXNG (privacy) + Tavily (AI-powered) | Any web search need |

## Prerequisites

Set `KNOWLEDGE_BASE` to the path of your knowledge base (markdown files the agents can search and write to):

```bash
# bash/zsh
echo 'export KNOWLEDGE_BASE=~/Nextcloud/Obsidian/Knowledge' >> ~/.bashrc

# fish
echo 'set -Ux KNOWLEDGE_BASE ~/Nextcloud/Obsidian/Knowledge' >> ~/.config/fish/config.fish
```

Replace the path with wherever you keep your markdown notes. All agents reference `$KNOWLEDGE_BASE`.

**After setting the variable, restart your shell session** (close and reopen your terminal, or run `exec $SHELL`). You'll also need to **restart Goose** — the `goosed` daemon only picks up environment variables at launch, not from your shell config after the fact.

## Installation

```bash
git clone https://github.com/yourname/goose-agents.git ~/GitHub/goose-agents
cd ~/GitHub/goose-agents
chmod +x install.sh
./install.sh
```

This creates symlinks from `~/.agents/` and `~/.config/goose/skills/` into the repo. Edits in the repo take effect immediately.

## Configuration: provider and model

Each recipe YAML has a `settings` block at the bottom with a hardcoded provider and model:

```yaml
settings:
  goose_provider: ollama_cloud    # ← change this
  goose_model: gemma4:31b         # ← change this
  max_turns: 30
```

You need to change these to match **your** Goose provider and model. The easiest way:

1. **Via the Goose GUI** — open Goose, go to Settings → Providers, set your provider and model. The agents will inherit your default.
2. **Manually** — edit the YAML files directly in `~/GitHub/goose-agents/recipes/` (the symlinks mean changes take effect immediately).

The current values are:

| Recipe | Provider | Model |
|--------|----------|-------|
| `echo` | `ollama_cloud` | `gemma4:31b` |
| `knowledge-curator` | `ollama_cloud` | `gemma4:31b` |
| `search` | `ollama_cloud` | `deepseek-v4-flash` |

If you use a local setup (Ollama, LM Studio), change `ollama_cloud` to your local provider name as configured in Goose.


