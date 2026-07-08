# goose-agents

Personal Goose agent definitions — recipes, agents, and skills for the [Goose](https://github.com/block/goose) AI agent framework.

## Before installing: set your knowledge base path

Several files contain the placeholder `/path/to/knowledge-base`. You need to replace it with your actual knowledge base path before running install.

For example, if your knowledge base lives at `/home/you/Nextcloud/Obsidian/Knowledge`:

```bash
cd goose-agents
sed -i 's|/path/to/knowledge-base|/home/you/Nextcloud/Obsidian/Knowledge|g' \
  agents/*.yaml recipes/*.yaml skills/knowledge-base/SKILL.md
```

This replaces the placeholder in all agent configs and the knowledge-base skill. The agent-reach skill has no path references, so it doesn't need changing.

## Installation

```bash
git clone https://github.com/Xarianne/goose-agents.git ~/GitHub/goose-agents
cd ~/GitHub/goose-agents

# Set your knowledge base path (see above)
sed -i 's|/path/to/knowledge-base|YOUR_KB_PATH|g' agents/*.yaml recipes/*.yaml skills/knowledge-base/SKILL.md

chmod +x install.sh
./install.sh
```

This **copies** files into `~/.agents/` and `~/.config/goose/skills/` (not symlinks). After editing repo files, re-run `./install.sh` to update the installed copies.

## Agents

| Agent | What it does | When to use |
|-------|-------------|-------------|
| **Echo** | Captures agent experiences, consolidates into compact judgment, reflects on past lessons | Session start (recall), session end (retain), weekly (consolidate) |
| **Knowledge Curator** | Writes/edits KB docs with proper frontmatter, citations, linking, log discipline | Any KB write or restructure |
| **Search** | Web research via SearXNG (privacy) + Tavily (AI-powered) | Any web search need |

## Configuration: provider and model

Each recipe YAML has a `settings` block with a provider and model. Change these to match your Goose setup. Edit the files in the repo, then re-run `./install.sh`.

### Via the Goose GUI

1. Open Goose and go to the **Recipes** tab
2. Click **Edit** on the recipe you want to change
3. Select your **Provider** and **Model** from the dropdowns
4. Save

#### Local models

If you run models locally (Ollama, LM Studio), select your local provider in the dropdown (e.g. `ollama` or `lmstudio`) and pick the model you have pulled. No API keys needed — the agents will call your local endpoint instead of a cloud API.

### Manually (edit the YAML)

```yaml
settings:
  goose_provider: ollama_cloud    # change this
  goose_model: gemma4:31b         # change this
  max_turns: 30
```

### Current values (for reference)

| Recipe | Provider | Model |
|--------|----------|-------|
| `echo` | `ollama_cloud` | `gemma4:31b` |
| `knowledge-curator` | `ollama_cloud` | `gemma4:31b` |
| `search` | `ollama_cloud` | `deepseek-v4-flash` |
