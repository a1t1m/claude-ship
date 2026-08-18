# The frontend rule

## When it fires

The diff touches any of:

    *.tsx *.jsx *.ts *.js *.vue *.svelte *.css *.scss *.less
    *.html *.astro  tailwind.config.*  and any component directory

## Load order — direction, then system, then polish

Loaded in **stage 2, before `design.md` is written**. Not in stage 3. Visual
direction is a design decision; applied afterwards it is paint over a shape that
was chosen without it.

1. **`frontend-design`** — aesthetic direction. What this should feel like, and
   why it should not read as a template. Decide typography, and the one or two
   choices that make it specific to this product.

2. **`ui-ux-pro-max`** — the concrete system. Palette, spacing scale, component
   patterns, the product-type conventions, chart types if data is displayed.
   This turns direction into tokens and named components.

3. **`emil-design-eng`** — polish and motion. Interaction states, the transitions
   that should be interruptible, the details that separate built from generated.

Each is missing-tolerant. If one is not installed, say so once and continue with
the others; do not stop and do not try to install anything.

## What a UI design must name before it is finished

- typography: family, the scale, and what carries weight
- colour: the tokens, and that they are defined for **both** themes
- spacing: the scale, not ad-hoc values
- every state for every interactive element: default, hover, active, focus,
  disabled, loading, empty, error
- what happens at 375px wide
- what happens when the data is empty, one item, and a thousand items

A design document missing these is not done, and PROVE's `a11y`, `visual`, and
`emil-polish` lenses will find exactly these gaps in round 1 — which is a slow,
expensive way to learn something stage 2 should have decided.

## In PROVE

UI in the diff also routes the `playwright-e2e`, `a11y`, `visual`, and
`emil-polish` lenses. They need the dev server command recorded in `state.json`
at stage 0. If no dev server can be started, those lenses degrade to static
review and must say so in their findings rather than claiming they drove a
browser.

## Figma

If the work starts from a Figma file, the `figma` skills own that translation —
invoke `figma-design-to-code` before implementing, and let it supply the design
context instead of guessing from a screenshot.
