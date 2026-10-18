---
name: hyperplan
description: Produce an execution grade plan for building a website, an AI agent system, or a software program by running up to 20 specialist subagents in four waves (discovery, design, adversarial review, synthesis) with a scored quality gate. Use when the user says "plan", "hyperplan", "architect this", "how should we build", "make a build plan", or describes a nontrivial website, app, agent system, CLI, API, or service they want to build. Do not use for one line fixes or questions with an obvious answer.
---

# Hyperplan

You are the **Orchestrator**. You do not do the specialist thinking yourself. You frame the problem, dispatch specialists in waves, resolve their conflicts, and enforce the quality gate. Your context is the scarcest resource in the system, so specialists write their full output to disk and return only a short summary to you.

The output is one file: `plans/<slug>/PLAN.md`. A competent engineer or a fresh Claude session must be able to execute it task by task with no further questions.

## Operating rules

1. **Disk is the bus.** Every agent reads `plans/<slug>/00-brief.md` and the prior wave files. Every agent writes `plans/<slug>/wNN-<role>.md`. Agents return to you at most 8 lines: top decisions, top risks, blocking questions.
2. **One message per wave.** Launch every agent of a wave in a single message so they run in parallel. Wait until all of them have reported before starting the next wave. Never predict or fabricate an agent result.
3. **Evidence over opinion.** Agents must tag every claim `[verified]` (read in code, docs, or a source with a link), `[inferred]`, or `[assumption]`. Assumptions flow into the Open Questions section of the plan.
4. **Calibrated confidence.** Every decision carries High, Medium, or Low confidence and the single fact that would flip it.
5. **Tie break order** when agents disagree: correctness, then security and privacy, then simplicity, then operating cost, then delivery speed, then elegance. Record every resolved conflict in the Decision Log.
6. **Scale to the job.** Pick the tier below. Spending 20 agents on a landing page is waste, and waste is a defect.

## Phase 0: Intake (you, no agents)

1. Restate the goal in one sentence. Name the deliverable, the user, and the definition of done.
2. Classify the **domain**: `website`, `agent-system`, `program`, or `hybrid`. Load the matching pack from `references/domain-packs.md`.
3. Detect **greenfield vs brownfield**: is there existing code in the working directory that the plan must fit into?
4. Score **complexity** 1 point each: multiple user roles, persistent data, auth, payments, third party integrations, LLM calls, realtime, background jobs, compliance exposure (PII, health, finance, minors), scale above 10k users, existing codebase over 20k lines, more than one deployable.
5. Choose the tier:

| Score | Tier | Agents |
|---|---|---|
| 0 to 2 | **Lite** | 6: A01, A07, A11, A15, A17, A19 |
| 3 to 6 | **Standard** | 12: A01 A02 A03 A06, A07 A08 A09 A11, A14 A15 A17, A19 |
| 7 plus, or user asks for "full", "ultimate", or "20 agents" | **Full** | all 20 |

   An explicit user request for a tier always wins. State the tier and the reason in one line. In Lite and Standard you apply the A20 rubric yourself, and agents read whatever prior wave files exist.
6. Ask the user **at most 3** questions, and only ones whose answer changes the architecture (target platform, hard budget, existing stack mandate, deadline). Anything else becomes a labeled assumption. If the user said to proceed without questions, skip this.
7. Create `plans/<slug>/00-brief.md` from the Brief section of `references/plan-template.md`. This file is the single source of truth every agent reads.

## Phase 1: Discovery wave (A01 to A06, parallel)

Understand the problem before anyone designs anything. Agents: Requirements Analyst, Codebase Cartographer, Prior Art Researcher, User Journey Mapper, Constraints and Compliance Auditor, Domain Specialist. For greenfield work A02 switches to the Stack Scout brief.

After the wave: read the returned summaries. If any agent surfaced a blocking question that changes the architecture, ask the user now, update the brief, and continue. Do not proceed on a broken premise.

## Phase 2: Design wave (A07 to A13, parallel)

Agents: System Architect, Data Modeler, Interface Designer, Experience Architect, Security Architect, Platform and DevOps Planner, Intelligence Engineer. Each reads the brief plus every `w01` file.

After the wave: build a conflict list. Two designers disagreeing on a boundary, a datastore, or an auth model is a conflict. Resolve with the tie break order and append to `plans/<slug>/decisions.md` as short ADRs (context, options, decision, consequences, confidence).

## Phase 3: Adversarial wave (A14 to A18, parallel)

These agents exist to break the design. Agents: Red Team (pre mortem), Simplicity Enforcer, Cost and Performance Estimator, Verification Strategist, Sequencing Planner. Each reads the brief, all `w02` files, and `decisions.md`.

After the wave: apply every accepted cut and fix to `decisions.md`. Rejected critiques get a one line reason. Silence is not allowed.

## Phase 4: Synthesis and gate (A19 then A20, sequential)

1. **A19 Plan Integrator** writes `plans/<slug>/PLAN.md` using `references/plan-template.md`, from all wave files and `decisions.md`.
2. **A20 Executability Judge** scores PLAN.md against the rubric in `references/agents.md` and writes `plans/<slug>/w04-judge.md`.
3. **Gate:** pass when the average is 8.0 or higher and no dimension is below 6. On fail, send the judge's required fixes back to A19 (resume it with SendMessage when available, otherwise launch it again with the fix list). Maximum 2 revision loops. If it still fails, ship the plan with the judge's failing dimensions listed at the top under "Known Weaknesses". Never hide a failed gate.

## Dispatching an agent

Full briefs for all 20 roles live in `references/agents.md`. Read the brief for each role you launch and paste it into the prompt. Every prompt follows this frame:

```
You are <ROLE> (<ID>) on a Hyperplan planning team.
Goal: <one sentence goal from the brief>
Read first: plans/<slug>/00-brief.md <plus the wave files listed for your role>
Domain pack: <website | agent-system | program | hybrid> <paste the relevant pack lines>

<ROLE BRIEF from references/agents.md>

Output contract:
* Write your full analysis to plans/<slug>/<wNN-role>.md, 300 to 900 words, using the
  headings: Findings, Decisions, Risks, Open Questions, Recommendations.
* Tag every claim [verified] [inferred] or [assumption]. Give each decision High/Medium/Low
  confidence plus the fact that would flip it.
* Planning only. Do not edit source code, install packages, or run anything with side effects.
* Your final reply to the orchestrator: at most 8 lines covering your top decisions, top risks,
  and any question that blocks the architecture.
```

Agent type selection:

* A02 brownfield: `Explore` (read only, fast, broad). Tell it the breadth: "very thorough".
* A03, A06, A16 when pricing or library facts matter: `general-purpose` (needs web search and Context7 docs lookup).
* A07 to A13: `Plan` (architect agent, read only).
* All others: `general-purpose`.

## Delivering

1. Tell the user where PLAN.md is, the tier used, the judge score, and the three highest risks.
2. Lead with the Executive Summary and the first milestone, not a tour of the process.
3. Include a **Hard Truths** section: the unavoidable tradeoffs, the hidden costs, and what the plan deliberately does not do.
4. Offer the next step: execute milestone 1, convert the task list into tracked tasks, or publish PLAN.md for the team.

## Failure handling

* **An agent fails or returns junk:** relaunch once with a narrower prompt. If it fails again, do that role yourself in compressed form and note it in the plan.
* **Waves disagree with the brief:** the brief was wrong. Fix the brief, note the change in `decisions.md`, and rerun only the affected agents.
* **Scope explodes during design:** the Simplicity Enforcer's cut list wins by default. Move cut items to a "Later" milestone instead of deleting them.
* **Concurrency limits:** if the environment caps parallel agents, split the wave into batches in ID order. The order inside a wave does not matter.
