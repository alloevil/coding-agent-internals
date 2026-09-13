# Snapshot: Hermes Agent docs — Security (the eight-layer model)

- Source: https://hermes-agent.nousresearch.com/docs/user-guide/security
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.

## Excerpt

<!-- lines 44-70 of the extracted page text -->
Security
On this page
Security
Hermes Agent is designed with a defense-in-depth security model. This page covers every security boundary — from command approval to container isolation to user authorization on messaging platforms.
Overview
​
The security model has eight layers:
User authorization
— who can talk to the agent (allowlists, DM pairing)
Dangerous command approval
— human-in-the-loop for destructive operations
File write safety
— denylist and optional write sandbox for
write_file
/
patch
Container isolation
— Docker/Singularity/Modal sandboxing with hardened settings
MCP credential filtering
— environment variable isolation for MCP subprocesses
Context file scanning
— prompt injection detection in project files
Cross-session isolation
— sessions cannot access each other's data or state; cron job storage paths are hardened against path traversal attacks
Input sanitization
— working directory parameters in terminal tool backends are validated against an allowlist to prevent shell injection

<!-- lines 70-80 of the extracted page text -->
Dangerous Command Approval
​
Before executing any command, Hermes checks it against a curated list of dangerous patterns. If a match is found, the user must explicitly approve it.
Approval Modes
​
The approval system supports three modes, configured via
approvals.mode
in
~/.hermes/config.yaml
:

