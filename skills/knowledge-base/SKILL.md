---
name: knowledge-base
description: "Search, read, and edit the user's personal knowledge base at $KNOWLEDGE_BASE. Load when the user asks about something that might be documented there, when they reference a topic you should look up, or when you need to save/find knowledge across sessions. Replaces the OpenKnowledge MCP server and Hindsight with direct shell-based access."
---

# Knowledge Base — shell-based access

The user maintains a personal knowledge base (KB) of 159+ markdown files at:

```
$KNOWLEDGE_BASE
```

This is a three-layer source-grounded knowledge base. You have full shell and file access via the `developer` extension — use it to search, read, and edit these files directly. No MCP server required.

## The three layers

```
external-sources/   raw sources, saved verbatim
      ↓ cite
research/           provisional analysis
      ↓ promote
articles/           canonical, decided knowledge
```

- **`external-sources/`** — Raw sources saved verbatim (web pages fetched, PDFs extracted, copied files). Immutable after capture. No analysis here.
- **`research/`** — Provisional analysis synthesizing external sources. Every factual claim cites a specific doc in `external-sources/`. Promote to `articles/` once findings are stable.
- **`articles/`** — Canonical knowledge, committed after a decision. Carries a `supersedes:` chain tying back to research docs.

Additional directories:
- **`context/`** — User profile, active tasks, and setup notes. Read this for background on the user and their environment.
- **`Projects/`** — Project-specific notes.
- **`log.md`** — Append-only audit trail of all changes.

## Searching the knowledge base

Use `ripgrep` (`rg`) for fast keyword search across all markdown files:

```bash
# Search everything (excludes .git, node_modules, .ok, .obsidian)
rg -i --type md "search term" $KNOWLEDGE_BASE -g '!{.ok,.obsidian,.claude,.cursor,.codex,.opencode,.agents,node_modules}'

# Search only articles (canonical knowledge)
rg -i --type md "search term" $KNOWLEDGE_BASE/articles

# Search only research
rg -i --type md "search term" $KNOWLEDGE_BASE/research

# List all files in a section
find $KNOWLEDGE_BASE/articles -name '*.md' | sort

# Read a specific file
cat "/path/to/file.md"

# Find files by name pattern
find $KNOWLEDGE_BASE -name '*keyword*' -name '*.md'
```

When the user asks a question that might be answered by existing docs, search first. Read the relevant files, then answer in chat with inline references to the source files you used (e.g., "According to [articles/Linux/Fedora/Fedora.md](articles/Linux/Fedora/Fedora.md)...").

## Reading context

At the start of a session or when you need background, read:

```bash
cat $KNOWLEDGE_BASE/context/user-profile.md
cat $KNOWLEDGE_BASE/context/tasks.md
```

These contain the user's profile, environment details, and current task list.

## Loading judgment from Echo

At the start of every session, also load active judgment from the Echo learning agent:

```
delegate(source: "echo", instructions: "recall")
```

This returns `lessons/judgment.md` — a compact, scored set of rules and preferences distilled from past sessions. It stays under 20 facts and helps you avoid repeating past mistakes.

At the end of every session, capture any corrections, preferences, or observations:

```
delegate(source: "echo", instructions: "retain: type=correction, fact=..., context=...")
```

Run consolidation periodically (weekly or via cron):

```
delegate(source: "echo", instructions: "consolidate")
```

## Writing to the knowledge base — delegate to the curator

**Do NOT write KB files directly.** When content needs to be created, edited, promoted, or restructured, **delegate** to the **`knowledge-curator`** recipe:

```
delegate(source: "knowledge-curator", instructions: "...")
```

The knowledge-curator agent handles:
- Frontmatter (title, description, status, sources, tags)
- Inline citations linking to `external-sources/`
- Relative markdown links (no dead links)
- `log.md` append discipline

### When to offer a write

Only offer to save content when ALL of these hold:
1. The answer **synthesizes across multiple docs** or surfaces a non-obvious fact
2. It's **reusable** — likely to be asked again or records a decision
3. **No existing doc already answers it** — search first
4. The answer is **sourced**, not speculation

When all hold, **offer** to the user first: "This pulls together [N docs] — want me to save it as `slug.md` under `folder/`?" On a yes, delegate to the knowledge-curator. Never auto-create pages — a junk page pollutes the corpus permanently.

### Quick lookups stay with the main agent

Reading and searching (`rg`, `cat`, `find`) are still done directly — no delegation needed for those.

## What this replaces

This skill replaces:
- **OpenKnowledge MCP server** — which crashed Goose's `goosed` process via stdio MCP
- **Hindsight** — which consumed 900 MB RAM for vectorized memory recall

You now do what both did, using shell tools that are faster and more reliable than MCP stdio transports.