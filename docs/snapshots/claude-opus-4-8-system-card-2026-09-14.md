# Snapshot: Claude Opus 4.8 System Card, section 8.2 (SWE-bench Verified)

- Source: https://www.anthropic.com/claude-opus-4-8-system-card (the vendor's PDF, 20,587,425 bytes)
- Fetched: 2026-09-14 (curl from this workstation; the PDF's text extracted with pdftotext, excerpt verbatim below)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.
- The PDF itself is not committed, only this excerpt of its text; section 8.2 is the section the repository's Claude Code page cites for the 88.6% figure.

## Excerpt

```
8.2 SWE-bench Verified, Pro, Multilingual, and Multimodal
SWE-bench (Software Engineering Bench) tests AI models on real-world software
engineering tasks. We report four variants, where the score is the average over 5 trials:
●​ SWE-bench Verified29 is a 500-problem subset, each verified by human engineers as
solvable. Opus 4.8 achieves 88.6%.
●​ SWE-bench Pro30 is a harder variant: problems drawn from actively-maintained
repositories with larger, multi-file diffs and no public ground-truth leakage. Opus
4.8 achieves 69.2%.
●​ SWE-bench Multilingual extends the format to 300 problems across 9
programming languages. Opus 4.8 achieves 84.4%.
29
```
