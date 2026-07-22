# gh / GraphQL command reference for PR review

Exact commands reused every review. Substitute `OWNER/REPO` and PR number.

## Gather

```bash
# Metadata + PR body (read the author's own "Testing"/"Deferred"/"Follow-ups" notes)
gh pr view <url> --json title,body,author,baseRefName,headRefName,state,additions,deletions,changedFiles,labels

# Changed file list
gh pr view <n> --repo OWNER/REPO --json files -q '.files[].path'

# Full unified diff (save it; the inline diff view truncates)
gh pr diff <url> --patch > /tmp/pr.diff

# Head SHA — required as commit_id for every inline comment
gh pr view <n> --repo OWNER/REPO --json headRefOid -q '.headRefOid'
```

Then check out the branch and read files in full context:

```bash
git fetch origin <headRefName> && git checkout <headRefName> && git log --oneline -3
```

## Inline comment on an exact line

The line MUST be part of the diff hunk (an added/changed line, or within a hunk's
context range). New files: any line works.

```bash
gh api repos/OWNER/REPO/pulls/<n>/comments -X POST \
  -f commit_id="<HEAD_SHA>" \
  -f path="src/path/to/file.ts" \
  -F line=42 \
  -f side="RIGHT" \
  -f body='markdown body here' \
  -q '.html_url'
```

Notes:
- `-F line=42` uses `-F` (typed) so it is sent as a number, not a string.
- `side=RIGHT` = the new version (the added line). `LEFT` = the deleted side.
- Multi-line range: add `-F start_line=40 -f start_side="RIGHT"`.
- If it 422s, the line is outside the diff; re-target an added line inside a hunk
  (`git diff main...HEAD -- <file> | grep -n '@@'` to find hunk ranges).

## Broad PR comment (not line-anchored)

```bash
gh pr comment <n> --repo OWNER/REPO --body-file /tmp/followups.md
# or --body "..."
```

## List review threads with IDs + resolved state

```bash
gh api graphql -f query='
{ repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: <n>) {
      reviewThreads(first: 50) { nodes {
        id isResolved
        comments(first: 5) { nodes { path line author { login } body } }
      } }
} } }'
```

Add `--jq '...'` to read another reviewer's comment bodies before touching their threads.

## Resolve a thread

```bash
gh api graphql \
  -f query='mutation($id: ID!) { resolveReviewThread(input: {threadId: $id}) { thread { id isResolved } } }' \
  -f id="PRRT_..." \
  --jq '.data.resolveReviewThread.thread | "resolved \(.id) → \(.isResolved)"'
```

## Approve / confirm decision

```bash
gh pr review <n> --repo OWNER/REPO --approve --body "..."
# or --comment --body / --request-changes --body

# Confirm it landed
gh pr view <n> --repo OWNER/REPO --json reviewDecision,latestReviews \
  --jq '{decision: .reviewDecision, reviews: [.latestReviews[] | {author: .author.login, state: .state}]}'
```

## Cross-repo (backoffice / sibling repos)

A fix may live in another repo's PR (e.g. the CRM comment references
`px-backoffice-us#16`). The CRM-side code and comment are verifiable here; the
other repo's guarantee is not. Verify what is in reach, and state plainly that
the cross-repo half rests on the author's claim rather than asserting it as checked.
