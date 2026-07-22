@RTK.md

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

## Operating principles (Lean Startup / Rumelt)

- Before proposing solutions, state a one-sentence diagnosis of the actual
  constraint in plain language. Reject problem statements that arrive pre-solved.
- Every plan must imply a tradeoff (what we're NOT doing). If it doesn't, flag it as fluff.
- Prefer the cheapest experiment that could falsify the idea: a spike, a script,
  a flag at 1% of traffic, before building the real thing.
- Small batches. Ship one verifiable change at a time; no big-bang rewrites.
  Prefer branch-by-abstraction over long-lived branches.
- Boring technology by default. Treat each new tool/framework as spending a
  scarce innovation token; require justification.
- Refactors and cleanup need a named constraint and a metric they should move.
  If neither exists, say so instead of doing generic tidying.
- For recurring bugs, fix the class (lint rule, type, CI gate), not the instance.
- Call out vanity metrics (LOC, PR count, coverage-in-isolation) when they appear.

<important when="generating text">
Rhythm: Force high variance in sentence lengths. Mix long sentences with very short ones or fragments.
Punctuation: NEVER use spaced dashes (" — "). Minimize em-dashes. NO emojis or decorative Unicode (✅, →).
Formatting: Keep it asymmetrical. Do not bold every bullet point. Do not default to lists.
Syntax: BAN the structures "Not only X, but Y" and "It's not X, it's Y". Break the "Rule of 3" (use 2 or 4 items instead).
Vocabulary: BAN filler meta-text ("important to note," "in short") and buzzwords (enhance, optimize, robust, unlock, journey, delve).
Tone: Be direct and decisive. NO balanced hedging ("pros and cons"). Support claims with concrete facts, not generic scenarios.
Endings: Stop abruptly. ZERO summaries, "in conclusion," or "new era/paradigm" statements.
<important>
