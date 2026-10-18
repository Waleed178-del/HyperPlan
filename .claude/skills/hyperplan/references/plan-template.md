# Templates

## Brief (`plans/<slug>/00-brief.md`)

```markdown
# Brief: <project name>

* **Goal:** <one sentence: deliverable, user, definition of done>
* **Domain:** website | agent-system | program | hybrid
* **Mode:** greenfield | brownfield (<path to code>)
* **Tier:** Lite | Standard | Full (<complexity score> points: <which factors>)
* **Primary success metric:** <one measurable number>

## Context
<what the user said, in their words where possible>

## Hard constraints
* Budget: <amount or unknown>
* Deadline: <date or unknown>
* Mandated stack or platform: <or none>
* Compliance exposure: <or none known>

## Assumptions
* [assumption] <each one, so agents can challenge it>

## Out of scope
* <anything the user excluded>
```

---

## Plan (`plans/<slug>/PLAN.md`)

```markdown
# <Project name>: Build Plan

> Tier: <tier> · Team: <n> specialists (<opus count> opus, <sonnet count> sonnet, <haiku count> haiku) · Judge score: <avg>/10 · Generated: <date>

## Known Weaknesses
<only if the gate failed after 2 loops: list the failing dimensions and why>

## 1. Executive Summary
<5 sentences maximum: what we build, for whom, how, how long, what it costs to run>

## 2. Goals, Non Goals, Success Metrics
| Type | ID | Statement | Measure |
|---|---|---|---|

## 3. Requirements
### Functional
| ID | The system shall | Acceptance test | Priority |
### Non functional
| ID | Requirement | Target | How measured |

## 4. Architecture
<Mermaid component diagram>
<component table: name, responsibility, owns data, interfaces>

## 5. Data Model
<Mermaid ER diagram, datastore choices, retention rules>

## 6. Interfaces
<API, tool, event, or CLI contracts including errors>

## 7. Experience
<routes or flows, human in the loop points, key states>

## 8. Security and Compliance
| Threat | Boundary | Control | Task ID |

## 9. Platform and Operations
<environments, hosting, CI/CD, observability with alert thresholds, backup and restore, rollback>

## 10. Milestones and Tasks
<Mermaid dependency graph of milestones>

### M1: <name> (goal: <demoable outcome>)
| ID | Task | Files | Acceptance criteria | Verify | Est | Depends |
|---|---|---|---|---|---|---|
| M1.1 | | | | `<command>` | 0.5d | |

### Later (deferred by the Simplicity Enforcer)
* <item>: <why deferred, what triggers bringing it back>

## 11. Verification Strategy
<test layers, requirement to test mapping, commands, definition of done>

## 12. Risk Register
| ID | Risk | Likelihood | Impact | Early signal | Mitigation task |

## 13. Cost and Effort
| Item | Low | Expected | High | Source |
<operating cost at launch, 10x, 100x · build effort per milestone>

## 14. Decision Log
<short ADRs from decisions.md: decision, options rejected, confidence, flip condition>

## 15. Open Questions
| Question | Why it matters | Default if unanswered | Owner |

## 16. Team Record
<staffing table from staffing.md: role, approved model and effort, reason · debates held and outcomes · unanswered board requests>

## 17. Hard Truths
<unavoidable tradeoffs, hidden costs, and what this plan deliberately does not do>
```
