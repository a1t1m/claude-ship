# ship — cheatsheet

## The one you actually use

    /ship "DEV-188 direct product RFQ"     start a run
    /ship "thoughts/tickets/DEV-188.md"    or point it at a ticket file
    /ship resume                           pick up a parked run
    /ship prove                            re-run the test fan-out only

Everything below is what `/ship` runs for you. You rarely type it yourself —
it is here for when you want to drive one piece directly.

## What happens, and where you stop

    0 FRAME       classify + detect            no stop
    1 UNDERSTAND  questions + parallel research
       ->  GATE 1   a window opens: the map, the evidence, the open questions
    2 DECIDE      approaches, design, slices, plan
       ->  GATE 2   a window opens: approaches, the phase board, decisions
    3 BUILD       worktree, TDD, one commit per slice
       ->  GATE 3   only if the plan diverges from reality
    4 PROVE       lenses -> refute -> fix -> repeat
       ->  GATE 4   a window opens: the verdict board
    5 SHIP        PR whose body carries the evidence

Bounded lane merges GATE 1 and GATE 2 into one. Spike lane skips all of it.

## In the gate window

    1-9      pick the option under the cursor
    j / k    next / previous question
    arrows   same as j/k
    tab      into the note field
    ⌘ + ↵    save and hand back
    ◐        light / dark

A **note beats the option you clicked** — write one whenever the options are all
slightly wrong. Partial answers survive: close the window, reopen it later.

## Where things land

    thoughts/ship/<id>/
        task.md questions.md research.md design.md structure.md plan.md
        state.json
        gates/<n>-<name>/review.json answers.json ANSWERS.md
        findings/round-<n>/findings.json summary.json raw/<lens>.json

Same filenames as QRSPI, so any `/qrspi/*` command can be pointed at that
directory when ship gets something wrong.

## bin/ship-preflight

    ship-preflight            what is installed, what degrades without it

Exit 1 means a hard requirement (python3, git) is missing.

## bin/ship-ui — the gate renderer

    ship-ui <dir>                        serve + open a window, wait for save
    ship-ui <dir> --no-open --print-url  headless / over SSH
    ship-ui <dir> --timeout 900          give up after N seconds (0 = wait)
    ship-ui <dir> --port 8899            pin the port

Reads `<dir>/review.json`, writes `<dir>/answers.json` + `ANSWERS.md`, exits on
save. Schema: `references/gates.md`.

## bin/ship-fanout — the test lenses

    ship-fanout --list-lenses            all 11 lenses and what triggers them
    ship-fanout --repo . --plan-only     which lenses this diff would run

    ship-fanout --repo ~/wt/app/DEV-188 \
                --out  thoughts/ship/DEV-188/findings \
                --base main \
                --context thoughts/ship/DEV-188/design.md \
                --round 1

    --lenses security,a11y     override routing, run exactly these
    --max-lenses 7             ceiling per round (overflow is printed, not dropped)
    --concurrency 5            how many run at once
    --timeout 900              seconds per lens
    --model sonnet             cheaper lenses
    --no-refute                skip refutation (faster, noisier)

Exit `0` dry round · `1` confirmed findings exist · `2` environment problem.

## The lenses

    always        functional  adversarial-edge  regression
    UI files      playwright-e2e  a11y  visual  emil-polish
    api / route   api-contract
    migration     migration-rollback          <- critical, never deferred
    auth / pay    security                    <- critical, never deferred
    models / db   data-integrity

Routed from the diff. A finding with no repro command and no observed output is
discarded before you ever see it.

## Loop control

Exit on two consecutive rounds with zero confirmed findings. Hard cap of four
rounds, then GATE 4 hands you the decision. It never silently gives up and never
silently ships with confirmed findings open.

## When you walk away

A gate waits 15 minutes, then parks the run and releases the session.
`/ship resume` picks it up with your partial answers intact. It will never
answer a gate on your behalf.

## Degrading

    no `claude`   PROVE falls back to in-session agents (weaker — shared framing)
    no `gh`       SHIP prints the PR body for you to paste
    no frontend skills   UI design is less opinionated; the run still completes
