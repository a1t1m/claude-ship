# Stage 1 — UNDERSTAND

QRSPI's `1_question` and `2_research` fused into one context. Fusing them is
where most of the audit time comes back: one context load instead of two, with
no loss of the property that makes QRSPI's research good.

## The property you must not break

Researchers answer **questions**, never "what should we build". A researcher who
knows the goal starts proposing solutions and stops reporting facts. QRSPI
enforced this with a hard context boundary between two commands. Fused, the
boundary must be enforced in the prompts instead:

> Give each research agent its questions and nothing else. Never paste `task.md`,
> the ticket, or the goal into a research agent's prompt. Instruct it explicitly:
> "Describe what exists. Do not suggest improvements or propose solutions."

If a research agent comes back with recommendations, that is a prompt leak. Drop
the opinions and keep the facts.

## Process

1. **Locate first.** One `codebase-locator` pass to learn what areas exist. You
   cannot write good questions about a codebase you have not glanced at.

2. **Write 3–7 neutral questions** into `questions.md`. Each should send a
   researcher somewhere different. Prefer "trace the flow" over yes/no.

   - Good: *How does the middleware chain authenticate a request, and where are
     auth policies defined?*
   - Bad: *What is the best way to add an authenticated endpoint?*

   Lane adjusts the count: **bounded** → 2–3 questions, **architectural** → 5–7.

3. **Fan out in parallel**, one message, multiple agents. 1–2 questions each.
   - `codebase-locator` — where things live
   - `codebase-analyzer` — how a specific path works, with `file:line`
   - `codebase-pattern-finder` — concrete existing examples to model on

4. **Wait for all of them.** Then synthesize. Where two agents disagree, read the
   code yourself and resolve it — do not report the contradiction as a finding.

5. **Write `research.md`** (~300 lines max). Every claim carries `file:line`.
   A claim you inferred rather than ran says so, in those words.

## GATE 1

Open the gate (protocol in `gates.md`). It must carry:

- **figures** — a picture of what currently exists: the flow being changed, the
  boundary being crossed. This is the map the user is buying with this stage.
- **evidence** — the `file:line` list, so a claim can be checked in one click.
- **questions** — every open decision the research surfaced, with options,
  costs, a rec, and a reason. Anything that needs human judgment goes here, not
  into an assumption.
- **notes** — what the research settled, so it does not get re-litigated later.

On the **bounded** lane, merge GATE 1 and GATE 2 into a single gate: the research
map plus the proposed approach and phases, answered once.
