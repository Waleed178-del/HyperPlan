# Hyperplan

A Claude Code skill that turns a build idea into an execution grade plan using up to 20 specialist subagents.

Built for three kinds of work: **websites**, **AI agent systems**, and **programs** (CLIs, APIs, services, apps, pipelines).

## How it works

```
Phase 0  Intake          Orchestrator frames goal, domain, tier, writes 00-brief.md
Wave 1   Discovery  x6   Requirements · Codebase/Stack · Prior Art · Journeys · Constraints · Domain
Wave 2   Design     x7   Architecture · Data · Interfaces · Experience · Security · Platform · Intelligence
Wave 3   Adversarial x5  Red Team · Simplicity · Cost · Verification · Sequencing
Wave 4   Synthesis  x2   Plan Integrator → Executability Judge (gate: avg ≥ 8, no score < 6)
```

Agents in a wave run in parallel. Each writes its full output to `plans/<slug>/` and returns only a short summary, so the orchestrator's context stays clean. Disagreements are resolved by a fixed tie break order (correctness, security, simplicity, cost, speed) and logged as ADRs.

The skill scales itself: **Lite** (6 agents), **Standard** (12), or **Full** (20), based on a complexity score. Ask for "full" to force all 20.

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
| `references/agents.md` | All 20 agent briefs plus the judge rubric |
| `references/domain-packs.md` | Website, agent system, and program expertise |
| `references/plan-template.md` | Brief and PLAN.md templates |

## Cost note

A Full run launches 20 subagents, several of them doing web research. Expect it to use many times the tokens of a single planning pass and to take several minutes. Use it for projects where a wrong architecture costs weeks. Use Lite for everything else.
