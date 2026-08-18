# Installing `ship`

## Install

```bash
cp -r ship ~/.claude/skills/
chmod +x ~/.claude/skills/ship/bin/*
~/.claude/skills/ship/bin/ship-preflight
```

That is the whole install. Restart Claude Code, then `/ship` is available.

Works the same on macOS and Linux. Nothing is written outside
`~/.claude/skills/ship/` and the repository you point it at.

## What it needs

| | | Without it |
|---|---|---|
| `python3` | **required** | Gates cannot render. Nothing works. |
| `git` | **required** | No worktree, no diff, no lens routing. |
| `claude` on PATH | recommended | PROVE falls back to in-session agents — weaker, since they share the session's framing. |
| `gh` | optional | The final stage prints the PR body for you to paste. |

No pip, no npm, no network. The gate window is plain HTML served from
`127.0.0.1` and works fully offline.

## Skills it drives

`ship` orchestrates skills rather than duplicating them. Each is optional; a
missing one is announced once and the run continues without it.

| Skill | Used for | Missing? |
|---|---|---|
| `superpowers:test-driven-development` | how code gets written in BUILD | falls back to ordinary test-first work |
| `superpowers:systematic-debugging` | when a test fails | falls back to ordinary debugging |
| `superpowers:brainstorming` | the three-path classification in FRAME | ship classifies on its own |
| `superpowers:writing-plans` | plan.md conventions | plan.md still gets written |
| `superpowers:finishing-a-development-branch` | how work integrates | ordinary merge/PR |
| `frontend-design` | UI aesthetic direction | UI design is less opinionated |
| `ui-ux-pro-max` | UI system, tokens, patterns | no design-system guidance |
| `emil-design-eng` | UI polish and motion | polish lens is weaker |
| `codebase-locator` / `-analyzer` / `-pattern-finder` | parallel research in UNDERSTAND | general-purpose agents instead |
| QA skills (`playwright-automation`, `accessibility-testing`, …) | depth per PROVE lens | lenses still run, with less domain guidance |

Superpowers is the one worth installing alongside it:
`/plugin install superpowers`.

## Optional: retire an older review console

If you already have `interactive-plans` and `~/.claude/bin/review-*`, `ship`
supersedes them — its `review.json` schema is a superset, so old specs still
load. Point `interactive-plans` at `ship` and leave the old binaries alone.

## Try it

```
/ship "add a --dry-run flag to the export command"
```

FRAME will classify it as bounded, so you get one merged gate rather than four.
A window opens by itself; you pick, save, and it carries on.

## Layout

```
ship/
  SKILL.md              the spine and the authority table
  INSTALL.md            this file
  bin/
    ship-ui             gate renderer — serves, opens a window, takes answers back
    ship-fanout         parallel `claude -p` test lenses with refutation
    ship-preflight      what is available and what degrades
  references/
    frame.md understand.md decide.md build.md prove.md ship.md
    gates.md state.md frontend.md
```
