# How Agents Work Together

Agents in the same wave run in parallel and cannot see each other while working. Collaboration therefore happens through four mechanisms, all routed by A21. The core rule that keeps it safe: **every file has exactly one writer.** Agents never edit each other's files, so parallel work cannot collide.

## 1. Relay (always on)

Each wave reads the files of every earlier wave. Wave 2 designers build on wave 1 facts. Wave 3 reviewers attack wave 2 designs. A19 reads everything. This is the backbone of collaboration.

## 2. Blackboard and huddle (after each wave)

**Raising a request.** Any agent that needs another role's input writes it in its own file under `## Requests to Peers`:

```
@A08: Does the order entity need soft delete? My retention control depends on it.
@A12: I need a secrets manager. Which one is in your platform plan?
```

**Routing.** After a wave reports, A21:
1. Collects every request from the wave files.
2. Discards requests already answered by an existing file (points the requester to the line).
3. Writes the open ones to `plans/<slug>/board.md` with an ID, sender, recipient, and status.
4. Resumes each recipient with SendMessage, sending only its requests. The recipient replies by appending a `## Replies` section to **its own** file, with each answer referencing the request ID, and returns one line per reply.
5. Marks each request answered on `board.md`. If an answer changes a requester's decision, resumes the requester once to update its own file.

**Limits:** one huddle round per wave, maximum 2 requests per agent per wave. Requests addressed to an agent in a later wave are held on `board.md` and pasted into that agent's dispatch prompt.

**board.md format**

```markdown
| ID | From | To | Request | Status | Answer at |
|---|---|---|---|---|---|
| R1 | A11 | A08 | Soft delete on Order? | answered | w02-data.md#replies |
| R2 | A07 | A16 | Cost of managed queue at 10x | held for wave 3 | |
```

## 3. Pair review (design wave, Standard and Full)

Each designer is paired with the role most likely to break its assumptions:

| Agent | Reviews |
|---|---|
| A07 Architect | A12 Platform |
| A12 Platform | A07 Architect |
| A08 Data | A09 Interfaces |
| A09 Interfaces | A08 Data |
| A10 Experience | A13 Intelligence |
| A13 Intelligence | A10 Experience |
| A11 Security | every design file, max 1 objection each |

When a partner is not staffed, review the nearest staffed role, or skip.

In the huddle step, A21 resumes each designer with: "Read your partner's file. Append `## Peer Review of <ID>` to your own file with at most 5 objections, each with severity (blocker, major, minor) and a proposed fix." Then A21 resumes each reviewed agent once with the objections against it to accept or rebut in its own file. Unresolved blockers become conflicts for A21.

## 4. Debate (contested decisions only)

Open a debate when a conflict is high impact, hard to reverse, and both sides have Low or Medium confidence.

1. A21 writes the question and the two positions in `decisions.md` as a pending ADR.
2. The agent holding position A is resumed to argue for it. A debate seat agent is launched to argue position B with the same model as the opposing agent. Both write to their own files: `w02-debate-<n>-a.md` and `w02-debate-<n>-b.md`. Maximum 400 words, evidence tagged.
3. One rebuttal round each, appended to their own file.
4. A21 decides using the tie break order and writes the final ADR, citing the winning evidence. A21 may also choose a third option that resolves both concerns.

Caps: Lite 0, Standard 1, Full 2 debates per run.

## 5. Rebuttal (adversarial wave)

After wave 3, A21 groups the critiques by target. Each targeted designer is resumed once with only the critiques against it and replies in its own file: accept (with the change), partially accept, or reject (with evidence). A21 records the outcome in `decisions.md`. A critique left unanswered counts as accepted.

## Cost control

Every resume is a model call. A21 skips any collaboration step with nothing to route, and never runs more than one round of any mechanism per wave. Collaboration is how agents reach a better answer, but when the routing list is empty it adds cost and changes nothing.
