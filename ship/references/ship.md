# Stage 5 — SHIP

## Before the PR

`superpowers:finishing-a-development-branch` decides how the work integrates.
Follow it. Then confirm, honestly:

- every phase in `plan.md` is ticked
- the last PROVE round was dry, or GATE 4 explicitly approved shipping with
  known findings — and those findings are going in the PR body
- the regression tests PROVE produced are committed

## The PR body

```bash
gh pr create --title "<under 70 chars>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets, the why from design.md — not a restatement of the diff>

## Design decisions
<the calls a reviewer needs to understand, from design.md and the gate answers>

## How this was verified
Lenses run: <list>   Rounds: <n>   Confirmed and fixed: <n>
<one line per confirmed finding: what it was, and the test that now guards it>

## Known gaps
<anything GATE 4 approved shipping with, or "none">

## Manual verification
- [ ] <the checks from GATE 4 that a human still owes>
EOF
)"
```

The "How this was verified" section is the point. A PR from this loop carries
evidence a reviewer can trust instead of a claim that it works.

**No `gh`?** Print the title and body for the user to paste. Do not fail the run.

## Attribution

Never add "Generated with", "Co-Authored-By: Claude", or any AI attribution to
commits, PR titles, or PR bodies. Plain messages.

## Close the run

Write the final `state.json` with the PR URL and `stage: "done"`, so a later
`/ship resume` reports the run finished rather than re-entering it.
