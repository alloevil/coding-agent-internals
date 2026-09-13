# Snapshot: Hermes Agent docs — Plugins (prompt-cache saving)

- Source: https://hermes-agent.nousresearch.com/docs/developer-guide/plugins
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.

## Excerpt

<!-- lines 2984-2992 of the extracted page text -->
Injected context is appended to the
user message
, not the system prompt. This is a deliberate design choice:
Prompt cache preservation
— the system prompt stays identical across turns. Anthropic and OpenRouter cache the system prompt prefix, so keeping it stable saves 75%+ on input tokens in multi-turn conversations. If plugins modified the system prompt, every turn would be a cache miss.
Ephemeral
— the injection happens at API call time only. The original user message in the conversation history is never mutated, and nothing is persisted to the session database.
The system prompt is Hermes's territory

