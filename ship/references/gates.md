# The gate — review.json

A gate is the only way this skill asks the user anything. Write `review.json`
into the run directory, then open it. You open it; the user never types a
launch command.

```bash
"$SKILL_DIR/bin/ship-ui" "<run-dir>"      # run_in_background: true
# poll for <run-dir>/answers.json, up to 15 min
# then read <run-dir>/ANSWERS.md
```

`ship-ui --no-open --print-url` serves without opening a window, for a headless
machine or when the user is on SSH.

## Schema

Every key optional except `title`. Unknown keys are ignored, so the format can
grow without breaking old specs.

```json
{
  "title":    "DEV-188  Direct Product RFQ",
  "subtitle": "stage 1 of 5",
  "stage":    "UNDERSTAND",
  "meta":     {"id": "...", "branch": "...", "lane": "architectural"},

  "figures":  [{"claim":   "one sentence — what this picture proves",
                "art":     ["ascii", "lines"],
                "svg":     "<svg …>  (alternative to art)",
                "tone":    "dim | good | bad | warn",
                "caption": "what it shows and why it matters"}],

  "notes":    [{"heading": "Settled", "lines": ["…"]}],

  "phases":   [{"id": "P1", "name": "…",
                "state": "done | next | planned | blocked",
                "commit": "abc1234",
                "what": ["…"], "files": ["…"], "proof": "the command"}],

  "questions":[{"id": "Q1", "q": "the question",
                "why": ["what makes this genuinely open"],
                "multi": false,
                "options": [{"id": "a", "label": "…",
                             "detail": "what this means",
                             "cost": "what it costs"}],
                "rec": "a", "rec_why": "the reasoning"}],

  "findings": [{"id": "…", "lens": "security", "severity": "blocker",
                "title": "…", "file": "…", "line": 12,
                "repro": "the command", "observed": "what happened",
                "verdict": "confirmed | refuted | open",
                "status": "fixed | open"}],

  "checks":   [{"id": "C1", "label": "manual verification still owed"}],
  "actions":  [{"id": "build", "label": "Approved — build it",
                "kind": "primary | danger | normal", "detail": "…"}],
  "evidence": [{"path": "src/auth.go", "line": 88, "note": "why this matters"}]
}
```

## Writing a gate worth opening

**Figures show the mechanism.** The hop being added or removed, the boundary
being crossed, what differs between two options. One claim per figure. A
before/after pair with `tone: "bad"` then `tone: "good"` beats one annotated
blob. Keep ASCII near 76 columns and prefer plain ASCII to box-drawing
characters — they survive every font. Use `svg` when the relationship is genuinely
spatial; use `art` for everything else.

**Questions are the main event, not an appendix.** Each carries `why` (what makes
it actually open), two to four options each naming its cost, a `rec`, and a
`rec_why`. The user should never have to reconstruct the question from prose.
A question with an obvious answer belongs in `notes` as settled.

**Notes keep the settled visibly apart from the open**, so a decision does not
get re-litigated and an assumption does not get mistaken for one.

**Evidence carries `path:line`.** A claim that was inferred rather than run says
so, in those words.

## Reading the answer

`ANSWERS.md` and `answers.json` appear together when the user saves.

- **A note outranks the option.** The radio button is a summary; the note is the
  actual instruction. If they conflict, follow the note and say that you did.
- **`UNANSWERED` means unanswered.** Do not fill it with the rec.
- **An overridden rec is a signal.** `ANSWERS.md` marks it. If the user rejected
  your recommendation, your model of the problem was wrong somewhere — reflect
  that in the next stage rather than routing around it.
- Re-opening a gate resumes from saved answers, so a half-answered gate is safe.

## Never

- Present research, a plan, options, or findings as terminal prose instead.
- Tell the user to run the console themselves.
- Invent an answer because the window was not answered. Park the run instead.
