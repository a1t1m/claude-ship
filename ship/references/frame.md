# Stage 0 — FRAME

The cheapest stage and the one that decides how much the rest costs. Under a
minute. Its job is to stop a one-line change from buying the full ceremony.

## Classify

Use the three paths from `superpowers:brainstorming`. ship performs this
classification so that skill's own flow does not need to run on top.

| Lane | What it means | What ship runs |
|---|---|---|
| **spike** | A feasibility question whose output is an answer, not code you keep | FRAME → a short probe → report. No gates, no PR. |
| **bounded** | A well-scoped change to a flow that **already exists in this repo** | FRAME → UNDERSTAND (2 researchers) → GATE 1 merged with GATE 2 → BUILD → PROVE → SHIP |
| **architectural** | New subsystem, new project, or a change that moves interfaces others depend on | every stage, every gate |

Bounded measures the repo, not your familiarity. If there is no existing flow to
read, it is not bounded. When torn between two lanes, take the heavier one — the
ratchet only goes up, and hidden complexity found mid-run upgrades the lane and
says so at the next gate.

## Detect

Record all of this into `state.json`; later stages must not re-derive it.

```bash
git rev-parse --show-toplevel          # repo root
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
git diff --name-only <base>...HEAD     # diff surface, if work already started
```

Then find, without asking the user:

- **test command** — `package.json` scripts, `Makefile`, `pyproject.toml`,
  `pytest.ini`, `go.mod`, `Cargo.toml`
- **dev server command** — needed by the browser lenses in PROVE
- **whether UI is in scope** — decides the frontend rule in stage 2
- **existing conventions** — a `CLAUDE.md`, `AGENTS.md`, or a QA context file at
  `.agents/qa-project-context.md` is authoritative over anything ship assumes

## Name the run

    thoughts/ship/<TICKET>-<slug>/        when a ticket id exists
    thoughts/ship/YYYY-MM-DD-<slug>/      otherwise

Create it, write `task.md` (2–3 sentences: what and why — this is what stops
later stages re-asking), and write `state.json`. Schema: `state.md`.

## Not in a git repo?

Say so and offer to `git init`. PROVE needs a diff to route lenses against and
BUILD needs a worktree. Do not silently run a degraded loop.
