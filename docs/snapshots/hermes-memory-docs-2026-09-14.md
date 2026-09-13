# Snapshot: Hermes Agent docs — Memory (memory caps, provider list, FTS5 session search)

- Source: https://hermes-agent.nousresearch.com/docs/user-guide/features/memory
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.
- Upstream language: English (the docs are served as one HTML page per topic).

## Excerpt

<!-- lines 52-70 of the extracted page text -->
Hermes Agent has bounded, curated memory that persists across sessions. This lets it remember your preferences, your projects, your environment, and things it has learned.
How It Works
​
Two files make up the agent's memory:
File
Purpose
Char Limit
MEMORY.md
Agent's personal notes — environment facts, conventions, things learned
2,200 chars (~800 tokens)
USER.md
User profile — your preferences, communication style, expectations
1,375 chars (~500 tokens)
Both are stored in
~/.hermes/memories/
and are injected into the system prompt as a frozen snapshot at session start. The agent manages its own memory via the
memory
tool — it can add, replace, or remove entries.

<!-- lines 328-341 of the extracted page text -->
​
Feature
Persistent Memory
Session Search
Capacity
~1,300 tokens total
Unlimited (all sessions)
Speed
Instant (in system prompt)
~20ms FTS5 query, ~1ms scroll
Cost
Token cost in every prompt
Free — no LLM calls

<!-- lines 756-764 of the extracted page text -->
Gating agent skill writes
.
External Memory Providers
​
For deeper, persistent memory that goes beyond MEMORY.md and USER.md, Hermes ships with 8 external memory provider plugins — including Honcho, OpenViking, Mem0, Hindsight, Holographic, RetainDB, ByteRover, and Supermemory.
External providers run
alongside
built-in memory (never replacing it) and add capabilities like knowledge graphs, semantic search, automatic fact extraction, and cross-session user modeling.

