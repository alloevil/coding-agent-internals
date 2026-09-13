# Snapshot: meshlaunch.com write-up of the Claude Code tracking incident

- Source: https://meshlaunch.com/en/blog/2026-claude-code-backdoor-miit-warning.html
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.
- Note: The same page also carries a third-party reverse-engineered domain count (147) and a v2.1.91 'Apr 2' start date; the repository deliberately publishes neither, so neither is reproduced here.

## Excerpt

<!-- lines 20-28 of the extracted page text -->
, run
claude --version
right now. Versions
2.1.91 through 2.1.196
shipped undisclosed code that covertly fingerprinted proxy users via
steganography
embedded in system prompts. On July 8, 2026, China's NVDB regulator classified this as a
severe security backdoor risk

<!-- lines 29-54 of the extracted page text -->
01
Is Claude Code Safe? TL;DR and Immediate Action
Claude Code
is Anthropic's terminal-based AI coding agent with file-system and shell access. The controversy is not about normal telemetry — it is about a
covert channel
that ran for nearly three months without any changelog disclosure.
1
Affected:
v2.1.91 (Apr 2) through v2.1.196 (Jun 29, 2026).
2
Fixed in:
v2.1.197+ (Jul 1–2, 2026; some reports cite v2.1.198).
3
Trigger:
Only when
ANTHROPIC_BASE_URL
points to a non-official proxy or gateway — official
api.anthropic.com
users were not fingerprinted.
4
Regulatory action:
China's NVDB (Jul 8) called it a backdoor; Alibaba banned Claude Code effective Jul 10.
5
Do now:
claude --version

<!-- lines 55-75 of the extracted page text -->
Date
Event
Feb 2026
Anthropic publicly invests in anti-distillation tech
Mar 2026
Covert detection mechanism deployed internally, undisclosed
Apr 2
v2.1.91 ships with hidden detection code
Jun 29
v2.1.196 — last affected release
Jun 30
Reddit exposure (LegitMichel777); reverse-engineering by Thereallo, Adnane Khan
Jul 1
Engineer Thariq Shihipar admits "experiment," promises rollback
Jul 2
v2.1.197 removes steganography code; changelog silent
Jul 3–4
Reuters, TechCrunch report Alibaba internal ban
Jul 8
China NVDB official backdoor risk advisory

