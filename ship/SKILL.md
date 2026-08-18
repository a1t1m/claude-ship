---
name: ship
description: Use when taking a task from idea to a proven pull request — research, design, build, then adversarial test fan-out that iterates until the work holds up. Every decision point opens as a real UI window instead of a wall of terminal prose. Use for "/ship", "take this to a PR", "close the loop on this", "build and test this properly", or any feature work that should end in a PR someone can trust. Also use when a plan, research finding, or design needs to be reviewed and answered.
---

# ship — the closed loop

One spine from a task to a pull request that has been attacked and survived.

This skill does not replace QRSPI or Superpowers. It **drives** them, and it owns
the three things neither provides: the gates where a human decides, the contract
each stage hands the next, and the loop back from "it is built" to "it is proven".

## The contract

    /ship "<task, ticket file, or issue URL>"     start
    /ship resume                                  pick up a parked run
    /ship prove                                   re-run the test fan-out only

    0 FRAME  → 1 UNDERSTAND → [GATE] → 2 DECIDE → [GATE] → 3 BUILD
                                     → 4 PROVE  → [GATE] → 5 SHIP

Between gates you run unattended. At a gate you stop and open a window.

## Preflight — run this first, once

```bash
"$SKILL_DIR/bin/ship-preflight"
```

It reports what is available and what degrades. Hard requirements are `python3`
and `git`. Everything else has a documented fallback — never abort a run because
an optional piece is missing, and never install anything to satisfy one.

`$SKILL_DIR` is this skill's own directory. Resolve it once at the start of a run
and reuse it; do not hardcode a path, because your friend's home is not yours.

## Authority — who owns which moment

This table is the whole answer to "the skills contradict each other". At any
moment exactly one thing is in charge. When in doubt, this table wins.

| Moment | In charge | It delegates to | Do NOT also run |
|---|---|---|---|
| Classifying the work | **ship FRAME** | — | `superpowers:brainstorming`'s full ceremony — ship's gates satisfy its approval requirement, see below |
| Finding out what exists | **ship UNDERSTAND** | `codebase-locator`, `codebase-analyzer`, `codebase-pattern-finder` | `/qrspi/1_question` and `/qrspi/2_research` as separate invocations |
| Choosing a direction | **ship DECIDE** | `frontend-design` → `ui-ux-pro-max` → `emil-design-eng` when UI is in the diff | `/qrspi/3_design`, `/qrspi/4_structure` separately |
| Writing the plan | **ship DECIDE** | `superpowers:writing-plans` for its conventions | — |
| Writing code | `superpowers:test-driven-development` | — | ship does not invent its own TDD |
| A test fails or something is weird | `superpowers:systematic-debugging` | — | guessing at a fix |
| Proving it works | **ship PROVE** | the installed QA skills, one per lens | treating `superpowers:requesting-code-review` as sufficient proof |
| Landing it | `superpowers:finishing-a-development-branch` | `/qrspi/8_pr` for the PR body | — |

**On brainstorming.** `superpowers:using-superpowers` requires the brainstorming
skill before creative work, and it is right to. ship satisfies that requirement
rather than skipping it: FRAME performs the same classification, and GATE 1 and
GATE 2 are the approval it demands — in a better medium. Read brainstorming's
three-path classification if you have not internalised it, then classify in FRAME.
Do not run its full question-by-question flow on top of ship's gates; that is the
double-process that made this skill necessary.

## The gate protocol

A gate is the only way this skill asks a question. Never present research, a
plan, a design, or a set of options as terminal prose.

**You open the window. The user never types a launch command.**

```bash
# 1. write the spec (schema: references/gates.md)
#    → <run-dir>/review.json

# 2. open it — background, because it blocks until answered
"$SKILL_DIR/bin/ship-ui" "<run-dir>"        # run_in_background: true

# 3. poll for the answer, up to 15 minutes
#    <run-dir>/answers.json appears when the user saves

# 4. read <run-dir>/ANSWERS.md and obey it
```

Rules that make a gate worth opening:

- **A free-text note beats the picked option.** If a question carries a note,
  that note is the answer; the radio button is a summary of it.
- **Every question carries a `rec` and a `rec_why`.** A question you have no
  opinion about is a question you have not thought about yet.
- **Two to four options, each with what it costs.** Not "Option A / Option B".
- **Figures show the mechanism**, not decoration: the hop being added, the
  boundary being crossed, what differs between two options. One claim per figure.
- **Never fabricate an answer.** If the window was not answered, nothing was
  approved. Parking is correct; assuming is not.

**On timeout (15 min, no answer):** stop the server, write `state.json`, and tell
the user the run is parked and `/ship resume` picks it up. Never proceed on the
recommendations, and never hold the session open indefinitely.

## The stages

Each stage has a playbook. Read the playbook when you enter the stage, not before.

| Stage | Playbook | Ends with |
|---|---|---|
| 0 FRAME | `references/frame.md` | a lane, a run directory, `state.json` |
| 1 UNDERSTAND | `references/understand.md` | `research.md` → **GATE 1** |
| 2 DECIDE | `references/decide.md` | `design.md`, `structure.md`, `plan.md` → **GATE 2** |
| 3 BUILD | `references/build.md` | commits per slice, in a worktree |
| 4 PROVE | `references/prove.md` | `findings.json` per round → **GATE 4** |
| 5 SHIP | `references/ship.md` | a PR whose body carries the evidence |

**Artifacts live in `thoughts/ship/<id>/`** with QRSPI-identical filenames —
`task.md`, `questions.md`, `research.md`, `design.md`, `structure.md`, `plan.md`.
Any `/qrspi/*` command can be pointed at that directory and will work, which is
your escape hatch when ship gets something wrong. Details: `references/state.md`.

## The frontend rule

When the diff touches `*.tsx *.jsx *.ts *.js *.vue *.svelte *.css *.scss *.html
*.astro`, three skills load **in stage 2, before the design is written** — not in
stage 3 as paint applied afterwards:

1. `frontend-design` — aesthetic direction, so it does not read as a template
2. `ui-ux-pro-max` — the concrete system: tokens, palettes, patterns, components
3. `emil-design-eng` — polish, motion, the states everyone forgets

Load them in that order: direction, then system, then polish. A design document
for UI work that does not name its typography, spacing scale, and interaction
states is not finished. Details and the skip conditions: `references/frontend.md`.

Any of the three missing? Say so once, continue with the rest.

## Resuming

`state.json` in the run directory holds the stage, the lane, the round, and every
gate answer so far. `/ship resume` reads it and re-enters at the recorded stage.
A parked gate keeps its partial answers — re-opening shows what was already picked.

## Red flags

| Thought | Reality |
|---|---|
| "I'll just summarise the plan in chat" | The gate is the medium. Prose in the terminal is what this skill exists to replace. |
| "I'll tell them to run ship-ui" | You open it. Handing over a command is the old behaviour. |
| "The user probably wants the recommendation" | Probably is not an answer. Park the run. |
| "PROVE is slow, one lens is enough" | One lens is a code review. The point is independent lenses that cannot share a blind spot. |
| "This finding is obviously real, skip the refuter" | Obvious findings are exactly the ones that turn out to be a stale build. |
| "No repro, but I'm confident" | A finding without a repro is dropped. Confidence is not evidence. |
| "It's a small change, skip FRAME" | FRAME is what makes a small change cheap. It costs one step. |
| "Tests pass, so it's proven" | Tests passing is the entry condition for PROVE, not its result. |
| "I'll run brainstorming as well, to be safe" | That is the double-process. FRAME plus the gates is the approval. |
| "The plan changed, I'll just adapt quietly" | Divergence opens GATE 3. Silent adaptation is how the plan stops being true. |
