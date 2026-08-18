# Stage 3 — BUILD

Execute `plan.md` phase by phase. This stage runs unattended: the user chose to
stop only at gates, so BUILD does not check in after every slice.

## Isolate first

```bash
git worktree add ~/wt/<repo>/<branch> -b <branch>
cp -r thoughts/ship/<id> ~/wt/<repo>/<branch>/thoughts/ship/<id>
```

The copy matters: untracked files in the main tree do not exist in a worktree,
and `plan.md` is untracked. Skipping it is the classic way this stage starts by
reading a file that is not there.

Confirm the worktree path and branch name with the user before creating it —
this is the one thing in BUILD that touches their filesystem outside the branch.

## Implement

`superpowers:test-driven-development` is in charge of how code gets written.
ship does not have its own opinion about that. Per slice:

1. Read every file the phase references **before** changing any of them.
2. Red: write the failing test. Green: make it pass. Then clean it up.
3. Run the phase's automated verification from `plan.md`.
4. Tick the checkbox in `plan.md` with an edit — that is the recovery mechanism
   if this session dies.
5. Commit the phase on its own: `Phase N: <name>`. One phase, one commit, so a
   later phase breaking something does not force reverting the good work.

Independent slices can go to parallel subagents via
`superpowers:subagent-driven-development`. Slices that touch the same files
cannot — do those in sequence.

## When something fails

`superpowers:systematic-debugging` takes over. Do not guess at a fix, do not
try three things at once, and do not weaken a test to make it pass. If a test
is wrong, say that it is wrong and why, out loud, before changing it.

## GATE 3 — divergence only

This gate fires only when reality contradicts the plan. Then it is mandatory:

> Expected: what `plan.md` says exists
> Found: what is actually there
> Impact: what this does to the remaining phases
> Options: adapt within the plan / re-plan this phase / re-open GATE 2

Silent adaptation is the failure mode here. The moment you adapt without saying
so, `plan.md` stops describing the work, and every later stage — including the
PR body — is built on a document that is no longer true.

## Exit condition

Every phase committed, every automated check in `plan.md` green. That is the
entry condition for PROVE, not proof of anything.
