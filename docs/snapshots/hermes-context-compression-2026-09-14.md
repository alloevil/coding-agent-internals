# Snapshot: Hermes Agent docs — Context compression and caching (threshold default and worked example)

- Source: https://hermes-agent.nousresearch.com/docs/developer-guide/context-compression-and-caching
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.

## Excerpt

<!-- lines 294-300 of the extracted page text -->
true
# Enable/disable compression (default: true)
threshold
:
0.50
# Fraction of context window (default: 0.50 = 50%)

<!-- lines 880-902 of the extracted page text -->
Before/After Example
​
Before Compression (45 messages, ~95K tokens)
​
[0] system:    "You are a helpful assistant..." (system prompt)
[1] user:      "Help me set up a FastAPI project"
[2] assistant: <tool_call> terminal: mkdir project </tool_call>
[3] tool:      "directory created"
[4] assistant: <tool_call> write_file: main.py </tool_call>
[5] tool:      "file written (2.3KB)"
... 30 more turns of file editing, testing, debugging ...
[38] assistant: <tool_call> terminal: pytest </tool_call>
[39] tool:      "8 passed, 2 failed\n..."  (5KB output)
[40] user:      "Fix the failing tests"
[41] assistant: <tool_call> read_file: tests/test_api.py </tool_call>
[42] tool:      "import pytest\n..."  (3KB)
[43] assistant: "I see the issue with the test fixtures..."
[44] user:      "Great, also add error handling"
After Compression (25 messages, ~45K tokens)
​
[0] system:    "You are a helpful assistant...
[Note: Some earlier conversation turns have been compacted...]"

