---
name: pragmatic-pr-review
description: "Review a GitHub pull request with a ship-oriented lens that protects security and extendability without applying book rules the codebase does not follow. This skill should be used when asked to review a PR, leave review comments, resolve review threads, verify that feedback was addressed, or approve a PR, and the reviewer wants a pragmatic judgment weighing developer and end-user experience rather than an exhaustive defect list. Covers gathering the diff, verifying claims against code, ranking findings by act-now vs defer vs accept, comment discipline, and the gh/GraphQL mechanics."
---

# Pragmatic PR Review

## Posture

Optimize for shipping the feature. Protect security and extendability along the
way, but do not apply a rule the rest of the codebase already ignores. Weigh
developer experience (is the fix cheap? does it fit existing patterns?) and
end-user or operator experience (does this actually help the person using the
app?) as first-class inputs.

Be decisive. Open with a verdict, give a recommendation, offer to act. A review
is not only a defect list. Name what is genuinely good and worth keeping as a
pattern.

Three non-negotiables that survive the pragmatism:
- Verify claims against the code, never trust a commit message or a PR "fixed in
  X" line on its face.
- Treat a public infoleak of raw exception text, secrets, or internal scoring as
  a different category from business data leaking.
- Respect human feedback: read another reviewer's thread before resolving it.

## Workflow

Track these as todos when the task spans more than a quick look.

### 1. Gather
Pull metadata, the PR body, and the full diff, then check out the branch and read
the changed files in full context. The diff alone is not enough; surrounding code
is where correctness and convention live. See `references/gh-commands.md` for the
exact commands.

Read the PR body's own Testing / Deferred / Follow-ups sections. Authors often
flag their own weak spots. That honesty is the bar, and it tells where to look.

Note the branch may lag `main`: reverted docs, stale generated artifacts, missing
sibling routes. Do not attribute those to the PR.

### 2. Verify, don't trust
- Read the actual code for every claim. When checking that prior feedback was
  addressed, confirm the fix in source, not in the commit message.
- Run the relevant tests and typecheck. Triage the output: separate real failures
  from stale or irrelevant noise (for example `.next/` validator types pointing at
  routes absent on this branch). State which is which rather than reporting noise
  as a finding.
- Respect precedent. If every sibling route is unauthenticated, do not demand this
  one add auth; flag the posture as a follow-up instead of a blocker.
- Cross-repo fixes: verify the half in reach, and say plainly that the other
  repo's guarantee rests on the author's claim.

### 3. Rank findings by action
Sort every finding into one bucket, biased toward shipping:

- **Fix now** — real and cheap, or a genuine security or data-safety issue. Give a
  concrete minimal fix (a 5-line sanitize, a 1-line clamp), not abstract advice.
  When a full fix is expensive, propose the cheap mitigation that ships now and
  leave the large fix to a follow-up (for example: cap and flatten raw error text
  server-side rather than blocking on a full auth refactor).
- **Defer** — real but not worth blocking; name it as a follow-up ticket.
- **Accept as-is** — idiomatic tradeoffs the author already made correctly (a
  hand-mirrored read-only schema for a cross-service read, a degraded-path layout
  quirk). Commenting here is just narrating correct decisions. Skip it.

### 4. Deliver and act
Present the review: verdict, the act-now items, then defer/accept notes, then what
is good. When asked to comment, apply the discipline below. When asked to resolve
and approve, verify each thread is addressed first, then resolve, then approve, then
confirm the decision landed.

## Comment discipline

Only comment what is actionable and worth the author's attention. On a clean PR the
right count is often one comment, sometimes zero.

- Do not narrate decisions the author made correctly.
- Do not leave standalone nitpicks. Fold trivial one-liners into one thread as an
  optional "P.S. while you're here" so they cost the author nothing and read as
  generosity, not pedantry.
- Frame security and defer calls explicitly: "agree with deferring the auth work,
  but sanitize this field now."
- Inline comments go on the exact line; broad notes go as a single PR comment.
- Do not auto-approve when a requested change is still open. Approve once it is
  addressed or the author gives an explicit won't-fix. Approving one's own PR is
  not possible; confirm authorship first.

## Writing style

Direct, decisive, varied sentence rhythm. Mix long sentences with short ones.
No spaced dashes, minimal em-dashes, no decorative Unicode or emojis. Never use
"not only X, but Y" or "it's not X, it's Y". Break the rule of three. Cut filler
("important to note", "in short") and buzzwords (enhance, optimize, robust, unlock).
Take a position instead of listing pros and cons. Support claims with the specific
file, line, and failure, not generic scenarios. Stop when done; no summary paragraph.

## Quality checklist

- [ ] Read the branch's actual code, not just the diff
- [ ] Verified every "fixed" claim in source
- [ ] Ran tests/typecheck and triaged real vs stale output
- [ ] Every finding bucketed: fix-now / defer / accept
- [ ] Fix-now items carry a concrete minimal patch
- [ ] Comments limited to actionable, attention-worthy items
- [ ] Verdict stated; good patterns named

## References

- `references/gh-commands.md` — exact gh CLI and GraphQL commands for gathering the
  diff, posting inline and broad comments, listing and resolving review threads, and
  approving. Load it when acting on a PR rather than just discussing it.
