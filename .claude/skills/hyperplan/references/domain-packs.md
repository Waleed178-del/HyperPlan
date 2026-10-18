# Domain Packs

Load the pack that matches the Phase 0 classification. For `hybrid`, load both relevant packs and give A06 both focus areas. Paste the relevant lines into every agent prompt so each specialist applies domain specific judgment.

---

## Website (marketing sites, web apps, SaaS, ecommerce, dashboards)

**A06 focus:** Web performance and rendering strategy specialist.

**Decisions that matter most**
1. Rendering mode per route: static, server rendered, client rendered, or incremental. Most sites overuse client rendering.
2. Content source: code, markdown, headless CMS, or database. Decide who edits content and how often.
3. Auth provider and session model, if any user accounts exist.
4. Hosting and edge strategy, including image optimization and caching headers.
5. Analytics and consent, which is a legal requirement in many regions.

**Default quality bars**
* Core Web Vitals at p75: LCP under 2.5 s, INP under 200 ms, CLS under 0.1.
* WCAG 2.2 AA. Keyboard navigable. Color contrast checked.
* Lighthouse performance and accessibility 90 plus on the critical journey.
* Semantic HTML, metadata, sitemap, structured data for SEO critical pages.
* Works at 320 px width with no horizontal scroll.

**Anti patterns**
* A single page app for a content site.
* Shipping a component library you do not need.
* No plan for forms: validation, spam protection, delivery, and failure states.
* Images without dimensions or modern formats.

---

## Agent System (LLM agents, multi agent workflows, copilots, automations)

**A06 focus:** Agent orchestration and evaluation specialist.

**Decisions that matter most**
1. Single agent with tools vs multiple agents. Default to one agent. Add agents only when context isolation, parallelism, or distinct permission scopes demand it.
2. Control flow: deterministic workflow with LLM steps, or an autonomous loop. Prefer the workflow wherever the path is known.
3. Tool surface: the smallest set of tools with tight schemas, clear errors, and least privilege permissions.
4. State and memory: what persists between turns and sessions, and what is deliberately forgotten.
5. Evaluation: a golden dataset, automated graders, and a pass threshold that gates every prompt or model change.

**Default quality bars**
* Every tool call validated against its schema. Every tool failure returns a message the model can act on.
* Hard limits on iterations, tokens, spend, and wall clock time per run.
* Human approval before any irreversible or outward facing action.
* Prompt injection treated as a given whenever untrusted content enters context.
* Tracing of every model call and tool call, with cost per run tracked.
* Model fallback path when the primary model errors or is overloaded.

**Anti patterns**
* Multi agent architectures added for elegance.
* No eval set, so prompt changes are judged by vibes.
* Tools that return huge raw payloads into context.
* Letting the model decide things a simple if statement could decide.

---

## Program (CLIs, APIs, services, libraries, desktop or mobile apps, data pipelines)

**A06 focus:** Runtime, platform, and maintainability specialist.

**Decisions that matter most**
1. Language and runtime matched to the deployment target and the team.
2. Distribution: package registry, container, binary, app store, or hosted service.
3. Configuration surface: flags, environment variables, files, and their precedence.
4. Error model: typed errors, exit codes, retries, and what the user sees.
5. Concurrency and resource model: threads, async, workers, queue, memory limits.

**Default quality bars**
* One command to build, one to test, one to run, documented in the README.
* Deterministic builds with pinned dependencies and a lockfile.
* Structured logs with levels. No secrets in logs.
* Public interfaces versioned with semantic versioning.
* For services: health check, graceful shutdown, timeouts on every outbound call.
* For pipelines: idempotent steps, resumable runs, data validation at each boundary.

**Anti patterns**
* Premature plugin systems and abstraction layers.
* Configuration with no validation and no defaults.
* Retries without backoff, jitter, or limits.
* No integration test against the real dependency.
