# Book concepts behind founder mode

Condensed reference for the frameworks SKILL.md invokes. Load when a step needs deeper grounding or the user asks where a rule comes from.

## Good Strategy Bad Strategy (Richard Rumelt)

### The kernel

Every good strategy has three parts, in order:

1. **Diagnosis** - a simplifying theory of what is actually going on; the critical challenge named plainly. Most common error: accepting the first definition of the problem offered. A codebase diagnosis looks like "deploys are slow because every service shares one migration lock and one CI pipeline", never "our infra is legacy".
2. **Guiding policy** - the overall approach chosen to deal with the diagnosed obstacles. A guardrail: it constrains and directs without specifying everything. Must imply a tradeoff; Will Larson's test: "If a guiding policy doesn't imply a tradeoff, you should be suspicious of it."
3. **Coherent action** - coordinated steps that carry out the policy and reinforce each other. Each refactor should make the next one cheaper. A scattershot backlog of "improve CI", "add tests", "reduce tech debt" tickets with no shared spine fails this part.

### The four hallmarks of bad strategy

1. **Fluff** - jargon creating an illusion of depth ("best-in-class platform", "cloud-native") with no diagnosis or tradeoff underneath.
2. **Failure to face the problem** - the challenge itself is never named, so the strategy cannot be judged.
3. **Mistaking goals for strategy** - "increase velocity 30%" is a desire, not a plan to overcome an obstacle.
4. **Bad strategic objectives** - a laundry list of things to do, each as hard as the original problem or unrelated to it.

### Sources of power

- **Leverage** - anticipation plus a pivot point plus concentration. Find the place where a small well-placed action produces disproportionate effect (the one shared module whose fix collapses six downstream problems) and concentrate there instead of spreading effort thin.
- **Proximate objectives** - targets close enough to be genuinely achievable. "Extract the payments module this quarter because it causes the on-call pages", never "migrate everything off the monolith". Cascade into smaller proximate slices per team.
- **Focus** - policies whose effects overlap and reinforce (one ORM convention, one error-handling convention) aimed at one area, rather than diffuse quality initiatives everywhere.
- **Chain-link systems** - system quality is capped by the weakest link; strengthening non-bottleneck components is waste. Reliability, onboarding time, and deploy speed are usually chain-link, gated by the legacy service everyone routes around. Explains why "everyone owns quality a little" fails.
- **Design-type strategy** - architecture as a deliberately coordinated configuration built for the specific diagnosed constraints, never a generic best-practices template.

### Inertia and entropy

- **Inertia** - organizations and codebases resist changing established routines after the environment shifts. Three kinds: routine, cultural, and by-proxy (downstream dependents resisting on your behalf).
- **Entropy** - absent active maintenance, systems drift toward disorder with zero external forcing: dependency drift, dead code, silently diverging conventions. This is the theoretical grounding for treating cleanup as active entropy management with its own kernel (what is decaying and why, what policy prevents recurrence, what commits enforce it), never optional polish.

### Engineering application (Will Larson / StaffEng)

Larson builds engineering strategy directly on the kernel: strategy docs carry diagnosis and guiding policy; coherent action is deferred to design documents. Most orgs have an implicit strategy nobody wrote down, so nobody can critique it and new hires fail their way into learning the real constraints.

## The Lean Startup (Eric Ries)

### Build-Measure-Learn

The central feedback loop: start from a hypothesis, build the smallest thing that tests it, measure real behavior, decide. Instrument before building; decide up front what signal would prove the idea wrong. Kent Beck's correction of common practice: the loop as practiced is backwards ("build, slap analytics on it"). His fix is Learn-Measure-Build: start from the question, decide what data answers it, then pick the cheapest instrument, which is sometimes a spike or load test rather than the real feature.

### MVP

Ries's definition: the version that allows maximum validated learning with least effort. For an engineer: the smallest diff, spike, or prototype that resolves a real unknown. Marty Cagan's corollary: the MVP is an experiment, never a product. Treat MVP code as disposable unless the experiment validates.

### Validated learning

The core currency. Excludes opinions, stakeholder confidence, and internal demos; requires evidence from real usage. A merged PR nobody uses counts as zero progress.

### Innovation accounting

For initiatives with unclear payoff (rewrite, framework swap, performance overhaul): set a baseline metric before starting, run the smallest change that could move it, and require movement before continuing investment. This stops "we've been refactoring for two quarters" from being self-justifying.

### Vanity vs actionable metrics

Vanity: LOC, PR count, story points, coverage-in-isolation, total signups. Actionable: change-failure rate, MTTR, deploy frequency correlated with defect rate, p99 tied to a specific change, error budget burn tied to a specific rollout.

### Pivot vs persevere

A structured decision gate after every loop, driven by data rather than sunk cost. Applies to technical bets: if the chosen architecture or library has not produced the expected metric movement inside the experiment window, change the underlying bet instead of polishing the same path.

### Small batches

From Ries's ACM Queue essay: batch size, cycle time, and risk are directly proportional. Small batches surface defects before they propagate; large batches hide them until fixing has compounded. Grounds small PRs, incremental migrations, continuous deployment, and Martin Fowler's branch-by-abstraction (mainline stays releasable throughout a large change instead of a giant high-risk branch merge).

### Five whys, and its limits

Ries's version: trace a failure to a human/process root cause, then invest proportionally to severity. Self-regulating: frequent severe problems pull more process investment automatically. The staff-level caveat (Allspaw, "The Infinite Hows"): five-whys assumes a single linear causal chain and terminates at scapegoats. For distributed-systems incidents, ask what conditions allowed the failure and assume multiple simultaneous contributing causes; run blameless postmortems that output mechanisms.

### Continuous deployment (Charity Majors)

Merge-to-main deploys automatically, no human gate. Requires four things: trust in the test suite, feature flags decoupling deploy from release, blameless culture, and observability for fast detection and rollback. "Testing in production" is an admission that complex systems cannot be fully known before shipping, so discipline shifts to fast detection and recovery rather than upfront perfection.

## Adjacent essentials

### Innovation tokens (Dan McKinley, "Choose Boring Technology")

A team holds a small budget of tokens for unproven technology; each unfamiliar tool or architecture consumes one. Spend them only where novelty serves the business; use boring tools with known failure modes everywhere else. Minimizing simultaneous unknowns is what makes failures isolable.

### Two cost curves (Kent Beck, "To Design or Not To Design?")

A connected (undesigned) system makes early features cheap; a modular (designed) system costs more upfront but keeps cost-per-feature flat as it grows. Pre-product-market-fit, deliberately under-invest in design ("if it's Thursday and the money lasts until Friday at 5, the responsible thing is another market experiment, not refactoring away duplication"). Post-validation, consciously switch curves and pay the debt down. The skill is identifying the current phase and timing the switch, never "always clean" or "always fast".
