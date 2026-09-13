# Snapshot: OpenAI announcement: Introducing GPT-5.5

- Source: https://openai.com/index/introducing-gpt-5-5/
- Fetched: 2026-09-14 (curl from this workstation, page HTML converted to text)
- Nature: point-in-time capture. Freshness is not checked; the receipts in `claims.json` compare the repository's published figures against this captured text only.
- The page is protected by an interstitial for plain HTTP clients; the text below was captured by rendering the URL in Chromium and reading the page's own text.
- Note: OpenAI publishes no SWE-bench Verified figure on this page; the terminal-bench row and the API context window are the two figures the repository quotes.

## Excerpt

<!-- lines 8-13 of the extracted page text -->
Log in
Try ChatGPT
(opens in a new window)
OpenAI
April 23, 2026

<!-- lines 112-116 of the extracted page text -->
is a weighted average of 10 evals ran by an external party: AA-LCR, AA-Omniscience, CritPt, GDPval-AA, GPQA Diamond, Humanity’s Last Exam, IFBench, SciCode, Terminal-Bench Hard, τ²-Bench Telecom.
Agentic coding
GPT‑5.5 is our strongest agentic coding model to date. On Terminal-Bench 2.0, which tests complex command-line workflows requiring planning, iteration, and tool coordination, it achieves a state-of-the-art accuracy of 82.7%. On SWE-Bench Pro, which evaluates real-world GitHub issue resolution, it reaches 58.6%, solving more tasks end-to-end in a single pass than previous models. On Expert-SWE, our internal frontier eval for long-horizon coding tasks with a median estimated human completion time of 20 hours, GPT‑5.5 also outperforms GPT‑5.4.
Across all three evals, GPT‑5.5 improves on GPT‑5.4’s scores while using fewer tokens.

<!-- lines 219-226 of the extracted page text -->
This work reflects our broader AI resilience approach, which we believe is needed as model capabilities advance. We want powerful AI to be available to the people using it to defend systems, institutions, and the public. The viable path is trusted access, robust safeguards that scale with capability, and the operational capacity to detect and respond to serious misuse.
Availability and pricing
Today, GPT‑5.5 is rolling out to Plus, Pro, Business, and Enterprise users in ChatGPT and Codex, and GPT‑5.5 Pro is rolling out to Pro, Business, and Enterprise users in ChatGPT. We’ll bring GPT‑5.5 and GPT‑5.5 Pro to the API very soon.
In ChatGPT, GPT‑5.5 Thinking is available to Plus, Pro, Business, and Enterprise users. GPT‑5.5 Pro, designed for even harder questions and higher-accuracy work, is available to Pro, Business, and Enterprise users.
In Codex, GPT‑5.5 is available for Plus, Pro, Business, Enterprise, Edu, and Go plans with a 400K context window. GPT‑5.5 is also available in Fast mode, generating tokens 1.5x faster for 2.5x the cost.
For API developers, gpt-5.5 will soon be available in the Responses and Chat Completions APIs at $5 per 1M input tokens and $30 per 1M output tokens, with a 1M context window. Batch and Flex pricing are available at half the standard API rate, while Priority processing is available at 2.5x the standard rate. We will also release gpt-5.5-pro in the API for even higher accuracy, priced at $30 per 1M input tokens and $180 per 1M output tokens. See the pricing page⁠ for full details.
While GPT‑5.5 is priced higher than GPT‑5.4, it is both more intelligent and much more token efficient. In Codex, we have carefully tuned the experience so GPT‑5.5 delivers better results with fewer tokens than GPT‑5.4 for most users, while continuing to offer generous usage across subscription levels.

