# Stage 4 — PROVE

Send independent Claudes to break the work. This is the stage that does not
exist in QRSPI or Superpowers, and it is the reason the loop closes.

## Why it is separate sessions

An agent that just implemented something cannot review it well. It knows why
each decision was made, so it reads the code as intended rather than as written.
Each lens is a real `claude -p` session with its own context: it has never seen
the reasoning, so it cannot inherit the blind spot.

## Run a round

```bash
"$SKILL_DIR/bin/ship-fanout" \
    --repo ~/wt/<repo>/<branch> \
    --out  thoughts/ship/<id>/findings \
    --base <base-branch> \
    --context thoughts/ship/<id>/design.md \
    --round N
```

Check what it will do first with `--plan-only`; list every lens with
`--list-lenses`. Lenses are routed from the diff — see the table in `SKILL.md`.
Capped at 7 per round; overflow is **deferred and printed**, never dropped
silently. `security` and `migration-rollback` outrank file-count when they match.

Exit code `0` = a dry round, `1` = confirmed findings exist, `2` = environment.

**No `claude` on PATH?** Fall back to in-session agents via the Agent tool, one
per lens, same mandates, same JSON contract. Say that you are doing this — the
fallback is weaker because the agents share this session's framing.

## What survives

`ship-fanout` enforces three filters so you do not spend the fix budget on noise:

1. **No repro, no finding.** A finding without a command and its real observed
   output is discarded before you see it.
2. **Deduplicated across lenses** by file, line bucket, and title stem. Two
   lenses finding the same thing is one finding with `also_found_by`.
3. **Refuted by an independent agent** whose job is to prove it wrong, defaulting
   to refuted when it cannot reproduce. Only survivors are `confirmed`.

## Fix and iterate

Fix `confirmed` findings only. For each one, write the failing regression test
first — the repro command is already in the finding, so the test is nearly free —
then fix, then confirm the test goes green. That test stays in the suite.
Speculative and refuted findings leave nothing behind.

Then re-run **only the lenses that fired**. A lens that came back dry does not
need re-running until the code it looks at changes.

## Loop control

- **Exit:** two consecutive rounds with zero confirmed findings.
- **Cap:** four rounds. On the cap, stop and open GATE 4 — never silently give up
  and never quietly ship with confirmed findings outstanding.
- Every round's `summary.json` and `findings.json` stay on disk as the record.

## GATE 4 — the verdict board

- **findings** — every finding with severity, lens, repro, verdict, and whether
  it was fixed. Refuted ones stay visible: they are evidence of what was checked.
- **figures** — the lens × round matrix, so the shape of the loop is legible.
- **checks** — the manual verification still owed that no agent can do.
- **actions** — ship it / run another round / hand it back to BUILD.
