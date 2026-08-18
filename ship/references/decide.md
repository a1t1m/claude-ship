# Stage 2 — DECIDE

QRSPI's `3_design` and `4_structure` fused, ending in `plan.md`. This is the
last cheap point to change direction. After this, changing your mind costs code.

## Order of operations

1. **Read GATE 1's `ANSWERS.md` first.** It is the input to this stage. A note
   the user wrote outranks the option they clicked.

2. **If UI is in the diff, load the frontend skills now** — before writing the
   design, in the order given in `frontend.md`. Visual direction is a design
   decision. Deferring it to stage 3 produces something that works and looks
   generated.

3. **Propose 2–3 approaches** with real trade-offs, grounded in what the research
   actually found — not generic architecture options. Lead with your
   recommendation and say why. YAGNI ruthlessly: cut every feature the task did
   not ask for from every approach before presenting it.

4. **Write `design.md`** (~200 lines): current state, desired end state, the
   decisions and why, patterns from this codebase to follow, and what is
   explicitly out of scope.

5. **Write `structure.md`** — vertical slices, each independently testable.

   Vertical, correct:
   > Phase 1: the "reticulate" endpoint — migration, store method, handler, and
   > the button that calls it. Verify: endpoint returns 200, button triggers it.

   Horizontal, wrong:
   > Phase 1: all migrations. Phase 2: all services. Phase 3: all endpoints.

   Order phases so that if phase 3 is abandoned, phases 1–2 are still worth
   having. Each phase lists: what it accomplishes, files affected, key
   signatures, and how to verify it — an automated command plus a manual check.

6. **Write `plan.md`** — the working document for stage 3. Exact paths, code
   snippets for anything non-trivial, and the verification command per phase.
   Follow `superpowers:writing-plans` conventions. Checkboxes per item: they are
   the progress tracker and the context-recovery mechanism.

## GATE 2

The most important gate in the loop. It carries:

- **figures** — before/after of the mechanism. Where two approaches differ,
  show them as a pair with `tone` set to `bad`/`good`, not as prose.
- **phases** — the board from `structure.md`, each with `what`, `files`, `proof`.
  This is where "what are you about to do to my repo" gets answered.
- **questions** — every decision still genuinely open. If a question has no real
  alternative, it is not a question; put it in `notes` as settled.
- **actions** — approve, or revise.

Do not enter BUILD without an answered GATE 2.
