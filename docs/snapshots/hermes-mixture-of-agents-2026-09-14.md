# Snapshot: Hermes Agent docs — Mixture of Agents (HermesBench table)

- Source: https://hermes-agent.nousresearch.com/docs/user-guide/features/mixture-of-agents
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.

## Excerpt

<!-- lines 426-442 of the extracted page text -->
Benchmarks
​
On HermesBench, a two-model MoA preset —
claude-opus-4.8
aggregating over a
gpt-5.5
reference — outscores either model run on its own:
Model
HermesBench score
Opus aggregator (opus-4.8 + gpt-5.5 reference) — MoA
0.8202
anthropic/claude-opus-4.8
0.7607
openai/gpt-5.5
0.7412
The MoA configuration beats its strongest component (opus-4.8) by ~6 points, confirming that aggregating a second perspective lifts quality on hard tasks rather than just averaging the two.

