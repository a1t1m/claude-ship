# ship

A closed loop for Claude Code: from a task to a pull request that has been
attacked and survived.

Every decision point opens as a **real window on your screen** — a diagram, the
evidence, and the open questions as things you pick — instead of a wall of
terminal prose. Every implementation is then attacked by **independent Claude
sessions** that have never seen the reasoning behind it, and only findings that
survive an adversarial refutation are worth your time.

```
/ship "DEV-188 direct product RFQ"

  0 FRAME       classify + detect                          no stop
  1 UNDERSTAND  questions -> parallel research
     -> GATE 1    window: the map, the evidence, the open questions
  2 DECIDE      approaches -> design -> slices -> plan
     -> GATE 2    window: approaches, the phase board, decisions
  3 BUILD       worktree -> TDD -> one commit per slice
     -> GATE 3    only if the plan diverges from reality
  4 PROVE       lenses -> refute -> fix -> repeat
     -> GATE 4    window: the verdict board
  5 SHIP        a PR whose body carries the evidence
```

## Why

Most agent workflows have three holes.

**Two processes, no contract.** If you run more than one methodology skill, both
claim the same territory and neither says who is in charge. `ship` ships an
**authority table**: at any moment exactly one thing owns the behaviour, and
everything else is explicitly deferred to.

**Decisions arrive as prose.** A plan you have to read as an essay is a plan that
does not get reviewed. `ship` renders every decision point as a gate — a picture
of the mechanism, the phases with their proof, and questions with two to four
options, each naming what it costs, plus a recommendation and the reasoning
behind it. You answer by picking. **The agent opens the window itself**; you
never type a launch command.

**Nothing tests the implementation but you.** The agent that wrote the code is
the worst possible reviewer of it — it knows what each line was *meant* to do, so
it reads intent rather than text. `ship` sends independent `claude -p` sessions,
routed from the diff, each with its own lens and none with access to the
implementer's reasoning.

## The evidence bar

This is the part that makes PROVE worth running.

1. **No repro, no finding.** A finding without a command and its real observed
   output is discarded before you ever see it.
2. **Deduplicated** across lenses by file, line bucket, and title stem.
3. **Refuted** by an independent agent whose job is to prove it wrong, defaulting
   to refuted when it cannot reproduce. Only survivors are `confirmed`.

Measured on a seeded repository: one lens found five genuine defects in 137
seconds, each independently reproduced by a refuter — and a deliberately
fabricated "memory leak" was refuted with `tracemalloc` and `ru_maxrss`
measurements across 101,000 calls rather than by hand-waving.

The loop exits after two consecutive rounds with zero confirmed findings, and is
hard-capped at four rounds. It never silently gives up and never silently ships
with confirmed findings open.

## Install

```bash
git clone <this repo> && cd claude-ship
./install.sh
```

Then restart Claude Code and run `/ship "your task"`.

Or by hand:

```bash
cp -r ship ~/.claude/skills/
chmod +x ~/.claude/skills/ship/bin/*
~/.claude/skills/ship/bin/ship-preflight
```

### Requirements

| | | Without it |
|---|---|---|
| `python3` | **required** | Gates cannot render. |
| `git` | **required** | No worktree, no diff, no lens routing. |
| `claude` on PATH | recommended | PROVE falls back to in-session agents — weaker, since they share the session's framing. |
| `gh` | optional | The final stage prints the PR body for you to paste. |

No pip, no npm, no network. The gate window is plain HTML served from
`127.0.0.1` and works fully offline. macOS and Linux.

## Optional companions

`ship` orchestrates rather than duplicates. Each of these is optional — a missing
one is announced once and the run continues without it.

| Skill | Used for |
|---|---|
| [`superpowers`](https://github.com/obra/superpowers) | TDD, systematic debugging, plan conventions, branch finishing |
| `frontend-design` | UI aesthetic direction |
| `ui-ux-pro-max` | UI system: tokens, palettes, patterns |
| `emil-design-eng` | UI polish, motion, interaction states |
| `codebase-locator` / `-analyzer` / `-pattern-finder` | parallel research agents |
| QA skills (`playwright-automation`, `accessibility-testing`, …) | depth per PROVE lens |

Superpowers is the one worth installing alongside it.

`ship` also drives a **QRSPI**-style command set if you have one: artifacts land
in `thoughts/ship/<id>/` with QRSPI-identical filenames, so any `/qrspi/*`
command can be pointed at that directory. That is the escape hatch for when
`ship` gets something wrong.

## The lenses

Routed from what the diff touches. Capped at 7 per round; overflow is **printed,
never silently dropped**. `security` and `migration-rollback` outrank file count
when they match — deferring the security lens because three CSS files matched
more globs is how a hole ships.

```
always        functional  adversarial-edge  regression
UI files      playwright-e2e  a11y  visual  emil-polish
api / route   api-contract
migration     migration-rollback     <- critical, never deferred
auth / pay    security               <- critical, never deferred
models / db   data-integrity
```

```bash
ship-fanout --list-lenses          # all of them and what triggers each
ship-fanout --repo . --plan-only   # what THIS diff would run, before you spend it
```

## Layout

```
ship/
  SKILL.md           the spine and the authority table
  CHEATSHEET.md      every command, one page
  INSTALL.md         install and degradation notes
  bin/
    ship-ui          gate renderer — serves, opens a window, takes answers back
    ship-fanout      parallel `claude -p` lenses with refutation
    ship-preflight   what is available and what degrades
  references/        frame · understand · decide · build · prove · ship
                     gates · state · frontend   (loaded on demand)
```

Full command reference: [CHEATSHEET.md](CHEATSHEET.md).

## Status

Every component is tested in isolation and the fan-out is verified live against a
seeded repository. The full five-stage run against a real ticket is the part that
still wants road-testing — treat the stage transitions as designed-and-plausible
rather than proven, and open an issue when one grinds.

## License

MIT.
