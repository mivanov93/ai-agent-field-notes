# Drafts — candidate field notes

Sixteen pages — the findings, one companion note (where the real savings come
from), and one derivative extension (marked ↳). First-draft text, written to
read on their own — titles and wording still to settle. The source incident is
named for each so the claim can be checked. Prior art has now been searched and
folded into each page; every verdict came back PARTIAL — the pieces are known,
the welded claim is the contribution.

**Titles are provisional.** This table is where we settle them.

**★** marks the drafts with the most original claim — a mechanism,
measurement, or framing the sweep found unnamed anywhere; read those first if
you know the field. **↳** marks a derivative note that extends someone else's
published work, credited in its title.

| Working title | One line | Where it came from |
|---|---|---|
| [AI is not Mr. Fix-IT](ai-is-not-mr-fix-it.md) | The umbrella: there is no incantation. "Fix it" in a loop doesn't converge, and bolting deep research onto it just buys the same wrong answer at huge cost. You supply the decomposition, the fact, the reframe, the check. | the story's deep-research money-burn |
| [A gate you can fail](a-gate-you-can-fail.md) | The model only fixes what something can reject; with no check to fail, it walks in dirty and no one is told. Build the gate. | model-fit measurement, ceiling vs floor |
| ★ [Decide the shape first](decide-the-shape-first.md) | A plan that lists only steps lets the code's structure be decided by accident — an 872-line object nobody chose. Design the shape, not just the behavior. | the room_chat structure retro |
| [Move the code, lose the test](move-the-code-lose-the-test.md) | Pulling shared code into one place can drop the tests that covered it while everything stays green. Re-check after the move. | the extraction retro |
| [All green, still broken](all-green-still-broken.md) | Dozens of passing checks, and the app sent zero packets — none of them asked the one question that mattered. When a thing goes load-bearing, re-ask what its tests are for. | the promotion retro |
| ★ [Notes that rot](notes-that-rot.md) | 85% of the comment defects were pointers to a work-session ("item 6, round A") that mean nothing later. Cite the reason, not the session. | the overcomplication audit |
| [The tools you never use](the-tools-you-never-use.md) | 0.6% of tool calls used a connected server; fifteen loaded packs were never called once, and all of them cost startup and context. Curate per project. | model-fit, tool-usage count |
| ["It can't be done" is usually out of date](it-cant-be-done-is-usually-out-of-date.md) | The "unsupported" browser feature had shipped twelve days earlier. A limitation is a measurement to take now, not a memory. | the WebKit fake-media incident |
| [It's already written down](its-already-written-down.md) | The model re-derived an answer the repo's own reference file already stated. Point it at the notes before it investigates. | the reference-doc re-derivation |
| [Don't interrupt a working agent](dont-interrupt-a-working-agent.md) | A steering message sent mid-task looked like an injection attack and got refused. Say it all up front. | the mid-run message refusal |
| ★ [You can't ask for cheaper](you-cant-ask-for-cheaper.md) | "Use fewer tokens" cuts the tests and reviews first, and the savings come back as bugs. Real economy is engineered, not requested. | this conversation + model-fit |
| ★ [Where the savings are](where-the-savings-are.md) | The honest half: cut what you didn't need — do the work once, write the scar tissue so a run doesn't fail, unload unused tools, cache what repeats — and never under-buy the model the job needs. | companion to the one above |
| [The docs aren't on the test](the-docs-arent-on-the-test.md) | The benchmarks that rank coding models — and the rewards they're trained on — score test-pass only, never doc or comment quality. The model optimizes what's graded; docs rot because nothing grades them. | benchmark check (verified) |
| [Where scar tissue comes from](where-scar-tissue-comes-from.md) | The retro — asking why the green checks missed it, not why the bug happened — is the ritual that mints each instruction-file rule. Leans KNOWN (SRE postmortems, escaped-defect analysis). | your prompt + the repo's own method |
| [The face transplant](the-face-transplant.md) | A mockup is cheap and looks like the goal, so the hard part seems done. Grafting it onto a real system is a face transplant, not a reskin — the system rejects a surface designed against no anatomy. Budget the application, not the mock. | your recollection + the ProtoI parity work |
| ↳ [Extension of Broekx: the shared git index](extends-broekx-shared-git-index.md) | Broekx named the shared-desk hazard and fixed it with worktrees; this adds the layer he skips — the shared git staging area, where an unscoped commit sweeps your half-staged work into the agent's. | extends Broekx (TDS, 2026) |

## Still open

- **Names and wording** — the point of this folder.
- **Section placement** — most are Failure modes or Methods; a few (the gate
  one) may be Principles. Decide when the titles settle.
- **Prior art** — searched and folded into every page (all PARTIAL). Still
  wants your read before any page is promoted to the main repo.
- **Merges** — "All green, still broken" and "A gate you can fail" are close
  cousins; they may be one page or two. "You can't ask for cheaper" and
  "Where the savings are" are a deliberate pair — the false way and the real
  way — meant to stay two.
