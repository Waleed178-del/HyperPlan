# Model and Effort Bidding

Before an agent starts real work, it recommends the model and effort level its task deserves. A21 approves, adjusts, or overrides. The bid round turns model choice from a guess into a recorded, reviewable decision.

## Why a separate bid call

An agent cannot change its own model after it starts. So the bid is a short, cheap call (`model: "haiku"`, `effort: "low"`) that reads the brief and the role brief, then predicts what the real work needs. The real work is launched afterward with the approved settings.

## Bid prompt

Launch one per staffed role, all in a single message.

```
You are bidding for the <ROLE> (<ID>) seat on a Hyperplan planning team.
Read plans/<slug>/00-brief.md and this role brief:
<ROLE BRIEF>
Do not do the work. Predict what it needs, using the rubric below.
<paste the Bid rubric section>
Reply with exactly these 5 lines and nothing else:
MODEL: haiku | sonnet | opus
EFFORT: low | medium | high | xhigh | max
DRIVERS: <the 1 to 3 rubric factors that decided it>
SCOPE: <small | medium | large> and why in under 15 words
RISK IF UNDERPOWERED: <what goes wrong if A21 downgrades you>
```

## Bid rubric

**Model**
* `haiku`: retrieval, mapping, inventory, formatting. The answer is found, not reasoned.
* `sonnet`: standard analysis with known patterns. Clear inputs, moderate tradeoffs. The default.
* `opus`: novel or ambiguous problems, irreversible decisions, many interacting constraints, adversarial thinking, or judging other agents' work.

**Effort**
* `low`: one pass, few sources, obvious answer.
* `medium`: compare a handful of options, check a few sources.
* `high`: multi constraint tradeoffs, several sources, careful verification.
* `xhigh`: adversarial analysis or a quality gate where a miss is costly.
* `max`: only when A21 explicitly permits it for a single critical seat.

**Escalate one step** for each that applies: the decision is hard to reverse, compliance exposure exists, the brief has many assumptions, brownfield code over 20k lines, or the role's output gates others (A07, A19, A20).

**De-escalate one step** for each that applies: small scope, greenfield with a mandated stack, Lite tier, or user asked for speed or low cost.

## Defaults table

Used when bidding is skipped, and as A21's sanity check against bids.

| ID | Role | Default model | Default effort |
|---|---|---|---|
| A01 | Requirements Analyst | sonnet | medium |
| A02 | Codebase Cartographer / Stack Scout | sonnet | medium |
| A03 | Prior Art Researcher | sonnet | medium |
| A04 | User Journey Mapper | sonnet | low |
| A05 | Constraints and Compliance Auditor | sonnet | medium |
| A06 | Domain Specialist | opus | high |
| A07 | System Architect | opus | high |
| A08 | Data Modeler | sonnet | high |
| A09 | Interface Designer | sonnet | medium |
| A10 | Experience Architect | sonnet | medium |
| A11 | Security Architect | opus | high |
| A12 | Platform and DevOps Planner | sonnet | medium |
| A13 | Intelligence Engineer | opus | high |
| A14 | Red Team | opus | xhigh |
| A15 | Simplicity Enforcer | sonnet | high |
| A16 | Cost and Performance Estimator | sonnet | medium |
| A17 | Verification Strategist | sonnet | medium |
| A18 | Sequencing Planner | sonnet | medium |
| A19 | Plan Integrator | opus | high |
| A20 | Executability Judge | opus | xhigh |
| Debate seat | Advocate | same as the role it opposes | same |

## Approval rules (A21)

1. **Opus seat cap:** Lite 3, Standard 5, Full 9. If bids exceed the cap, grant opus to the seats whose output gates others first (A19, A20, A07, A14, A11), then by the strength of "RISK IF UNDERPOWERED".
2. **Effort cap:** `max` is granted at most once per run and only with a written reason. `xhigh` at most 3 times.
3. **Bids more than one step from the default** need a driver that matches the rubric. Otherwise revert to the default.
4. **User budget wins.** If the user asked for low cost, cap every seat at sonnet and high except A19 and A20.
5. **Underperformance:** if an agent's output fails the judge or is junk, relaunch it one model step up. Record it in `staffing.md`.
6. **Record everything:** bid, approved setting, and the reason for any change, in `staffing.md`.
