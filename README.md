# Hyperplan

A Claude Code skill that turns a build idea into an execution grade plan. An orchestrator agent (A21) commands up to 20 specialist subagents, lets each one bid for its own model and effort level, and makes them collaborate before a judge gates the result.

Built for three kinds of work: **websites**, **AI agent systems**, and **programs** (CLIs, APIs, services, apps, pipelines).

## How it works

```
Phase 0  Intake          A21 Orchestrator frames goal, picks headcount, roster, topology
Phase 1  Bid round       Each staffed agent recommends its model + effort, A21 approves
Wave 1   Discovery  x6   Requirements · Codebase/Stack · Prior Art · Journeys · Constraints · Domain
Wave 2   Design     x7   Architecture · Data · Interfaces · Experience · Security · Platform · Intelligence
Wave 3   Adversarial x5  Red Team · Simplicity · Cost · Verification · Sequencing
Wave 4   Synthesis  x2   Plan Integrator → Executability Judge (gate: avg ≥ 8, no score < 6)
```

Agents in a wave run in parallel. Each writes its full output to `plans/<slug>/` and returns only a short summary, so the orchestrator's context stays clean. Disagreements are resolved by a fixed tie break order (correctness, security, simplicity, cost, speed) and logged as ADRs.

**A21 decides the team.** It starts from a tier (**Lite** 6, **Standard** 12, **Full** 20) based on a complexity score, then drops roles the project does not need and adds ones a trigger demands. Ask for "full" to force all 20.

**Agents bid for their model.** Before real work, each agent makes a cheap haiku call that recommends `haiku`, `sonnet`, or `opus` and an effort level from `low` to `max`, with reasons. A21 approves within caps (opus seats, max effort) and records every decision in `staffing.md`.

**Agents work together.** Every file has one writer, so parallel work never collides. Agents raise `@A08: question` requests, A21 routes them through a blackboard in a huddle after each wave, designers review each other in pairs, contested decisions get a structured debate, and attacked designs get a rebuttal round.

## Install

Project scope (one repo):
```bash
mkdir -p .claude/skills && cp -r /path/to/hyperplan/.claude/skills/hyperplan .claude/skills/
```

User scope (every project):
```bash
mkdir -p ~/.claude/skills && cp -r .claude/skills/hyperplan ~/.claude/skills/
```

Or run `./install.sh` (user scope) from this repo.

## Use

```
/hyperplan Build a SaaS dashboard for gym owners with Stripe billing and member check in
/hyperplan full: a multi agent research assistant that reads PDFs and writes cited reports
```

Or just describe what you want to build and ask for a plan. The skill triggers on planning requests.

## Output

```
plans/<slug>/
  00-brief.md        single source of truth every agent reads
  staffing.md        headcount, roster changes, bids and approved models
  board.md           peer requests routed between agents
  w01-*.md … w03-*.md specialist reports
  decisions.md       ADR log of resolved conflicts
  w04-judge.md       rubric scores and required fixes
  PLAN.md            the deliverable
```

PLAN.md contains requirements with acceptance tests, architecture and data diagrams, interface contracts, a threat model, milestones of tasks no larger than one day (each with files, acceptance criteria, and a verify command), a risk register, cost ranges at 1x/10x/100x, open questions, and a Hard Truths section.

## Files

| File | Purpose |
|---|---|
| `.claude/skills/hyperplan/SKILL.md` | Orchestration protocol |
| `references/orchestrator.md` | A21 playbook: staffing, roster rules, topology |
| `references/model-bidding.md` | Bid protocol, rubric, defaults, approval caps |
| `references/collaboration.md` | Blackboard, huddle, pair review, debate, rebuttal |
| `references/agents.md` | A21 plus all 20 agent briefs and the judge rubric |
| `references/domain-packs.md` | Website, agent system, and program expertise |
| `references/plan-template.md` | Brief and PLAN.md templates |

## Cost note

A Full run launches 20 bid calls, 20 subagents, and the collaboration resumes, several of them doing web research. Expect it to use many times the tokens of a single planning pass and to take several minutes. Use it for projects where a wrong architecture costs weeks. Use Lite for everything else.
