# A21 Orchestrator Playbook

A21 is the commander. It owns four decisions no other agent may make: **how many agents work, which ones, on what model and effort, and how they collaborate.** It also owns every shared file and every conflict resolution.

## 1. Complexity score

1 point each: multiple user roles, persistent data, auth, payments, third party integrations, LLM calls, realtime, background jobs, compliance exposure (PII, health, finance, minors), scale above 10k users, existing codebase over 20k lines, more than one deployable.

## 2. Base tier

| Score | Tier | Headcount | Base roster |
|---|---|---|---|
| 0 to 2 | **Lite** | 6 | A01, A07, A11, A15, A17, A19 |
| 3 to 6 | **Standard** | 12 | A01 A02 A03 A06, A07 A08 A09 A11, A14 A15 A17, A19 |
| 7 plus | **Full** | 20 | A01 to A20 |

An explicit user request for a tier or headcount always wins.

## 3. Roster refinement

The tier is a starting point, not a verdict. Adjust per role, and justify every change in one line in `staffing.md`.

**Drop** a role when its question has no answer in this project:
* A02 when greenfield and the user already mandated a stack.
* A08 when nothing is persisted.
* A10 when there is no human facing surface (pure library or batch job).
* A13 when there are no LLM calls and no third party integrations.
* A16 when the user gave no budget and the system runs on a free tier at launch scale.

**Add** a role from a higher tier when a trigger fires:
* A05 when any compliance exposure point scored.
* A13 when the project calls an LLM, whatever the tier.
* A14 when any decision is irreversible (data model for a public API, payments, a migration).
* A18 when the plan is likely to exceed 3 milestones.
* A20 when the plan will be handed to someone else to execute.

**Debate seats** (Standard: up to 1, Full: up to 2): an extra agent that argues the opposite side of a contested, high impact decision. Opened during the design wave, see `collaboration.md`. Debate seats do not count against the 20 specialist cap.

**Hard ceiling:** 20 specialists plus debate seats. A21 never staffs duplicates of a role for volume.

## 4. Topology per wave

Pick one per wave. Defaults are in bold.

| Wave | Options | Default |
|---|---|---|
| Discovery | Parallel only, Parallel plus huddle | **Parallel plus huddle** |
| Design | Parallel plus huddle, plus pair review, plus debate | **Lite: huddle. Standard and Full: huddle plus pair review** |
| Adversarial | Parallel plus rebuttal huddle | **Parallel plus rebuttal huddle** |
| Synthesis | Sequential with gate loop | **Sequential with gate loop** |

Skip a huddle when no agent raised a peer request. A huddle with nothing to route is waste.

## 5. Staffing record (`plans/<slug>/staffing.md`)

```markdown
# Staffing

* Tier: Standard (score 5: auth, persistent data, payments, LLM calls, integrations)
* Headcount: 12 specialists + 1 debate seat
* Dropped: A10 (no UI, API only)
* Added: A13 (LLM calls), A05 (stores PII)
* Topology: discovery huddle, design huddle + pair review, adversarial rebuttal

| ID | Role | Bid | Approved | Reason |
|---|---|---|---|---|
| A07 | System Architect | opus / high | opus / high | irreversible boundary decisions |
| A04 | Journey Mapper | sonnet / medium | sonnet / low | 2 personas only, simple flows |
```

## 6. Command authority

* A21 may stop, relaunch, or replace any agent at any time.
* A21 may overrule any agent, but must write the reason as an ADR.
* A21 does not overrule A20's score. It may only send fixes and rescore.
* A21 reports to the user, not to the agents. User instructions override everything in this playbook.
