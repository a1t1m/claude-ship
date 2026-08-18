# Run state and artifacts

## Layout

```
thoughts/ship/<id>/
    task.md          what and why, 2-3 sentences        (stage 0)
    questions.md     the neutral research questions     (stage 1)
    research.md      facts with file:line               (stage 1)
    design.md        current → desired, decisions        (stage 2)
    structure.md     vertical slices with checkpoints   (stage 2)
    plan.md          the working document, checkboxes   (stage 2)
    state.json       the run itself
    gates/<n>-<name>/
        review.json  the gate spec
        answers.json the picks
        ANSWERS.md   the readable answer
    findings/round-<n>/
        findings.json  every finding with its verdict
        summary.json   counts per lens
        raw/<lens>.json the untouched lens output
```

Filenames match QRSPI deliberately. Point any `/qrspi/*` command at this
directory and it works — that is the escape hatch when ship gets something
wrong. The folder differs (`thoughts/ship/` not `thoughts/qrspi/`) so a manual
QRSPI run and a ship run cannot overwrite each other.

## state.json

```json
{
  "id": "DEV-188-direct-rfq",
  "lane": "architectural",
  "stage": "PROVE",
  "created": "2026-08-18",
  "repo": "/Users/x/code/app",
  "worktree": "/Users/x/wt/app/DEV-188-direct-rfq",
  "branch": "DEV-188-direct-rfq",
  "base": "main",
  "ui_in_scope": true,
  "commands": {"test": "npm test", "dev": "npm run dev"},
  "gates": {"1-understand": "answered", "2-decide": "answered"},
  "prove": {"round": 2, "dry_rounds": 0, "confirmed_open": 3},
  "pr": null
}
```

Write it at the end of every stage and every gate. It is the only thing that
makes `/ship resume` cheap.

## Resume

`/ship resume` reads `state.json` and re-enters at `stage`:

- **Parked at a gate** → re-open the same `review.json`; partial answers are
  still there.
- **Mid-BUILD** → read `plan.md`, find the first unticked checkbox, continue.
- **Mid-PROVE** → read the last `summary.json`, continue from `round + 1`.
- **`stage: "done"`** → say the run finished and show the PR, do not re-enter.

If several runs exist, list them with their stage and let the user pick. Never
guess which run they meant.

## Cleanup

Nothing here is deleted automatically. `thoughts/` is the durable record of why
the code looks the way it does — the raw lens output in particular is what lets
someone reconstruct what was checked six months later.
