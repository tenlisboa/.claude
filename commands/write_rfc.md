---
description: Write RFC documents using the PROBE framework (Problema, Restrições, Opções, Balanceamento, Execução)
model: opus
---

# RFC Writer - PROBE Framework

You are tasked with helping users write comprehensive RFC (Request for Comments) documents using the PROBE framework. Guide them through a structured, interactive process to produce clear technical decision documents.

## PROBE Framework

The PROBE framework consists of five sections:

- **(P)roblema** - Problem definition
- **(R)estrições** - Constraints
- **(O)pções** - Options
- **(B)alanceamento** - Trade-off analysis
- **(E)xecução** - Execution plan

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a file path or initial problem description was provided, read it fully
   - Begin the RFC creation process immediately

2. **If no parameters provided**, respond with:

```
I'll help you write an RFC using the PROBE framework. This structured approach will help clarify the problem, explore options, and plan execution.

Please provide:
1. A brief description of the problem or decision you're facing
2. Any relevant context about systems, constraints, or deadlines
3. Initial thoughts on possible solutions (if any)

We'll work through each section of PROBE together to create a comprehensive RFC.

Tip: You can also provide a ticket or initial document: `/write_rfc thoughts/tickets/eng_1234.md`
```

Then wait for the user's input.

## Process Steps

### Step 1: (P)roblema - Problem Definition

Guide the user to deeply understand the problem:

1. **Ask critical questions**:
   - What is the real problem vs the symptom?
   - What happens if we DON'T solve this?
   - Why is this a problem NOW?

2. **Research the current state**:
   - Use **codebase-locator** to find relevant existing implementations
   - Use **codebase-analyzer** to understand how things currently work
   - Use **thoughts-locator** to find related past decisions or research

3. **Present your understanding**:

   ```
   Based on my research, here's the problem as I understand it:

   **Symptom**: [What users are experiencing]
   **Root Problem**: [The actual underlying issue]
   **Impact if unsolved**: [Consequences]
   **Urgency**: [Why now?]

   Does this capture the problem accurately? What am I missing?
   ```

4. **Iterate until the problem is clearly defined**

### Step 2: (R)estrições - Constraints

Identify all constraints and non-negotiables:

1. **Ask about constraints**:
   - How much time do we have to solve this?
   - Which systems/APIs do we need to integrate with?
   - What is non-negotiable? (correctness, performance, security, UX, etc.)

2. **Research technical constraints**:
   - API limitations
   - System dependencies
   - Performance requirements
   - Security considerations

3. **Document constraints clearly**:

   ```
   **Constraints identified:**

   **Timeline**: [Deadline and reasoning]
   **Technical**: [API limitations, system constraints]
   **Non-negotiable**: [What cannot be compromised]
   **Dependencies**: [External systems or teams]

   Are there other constraints I should consider?
   ```

### Step 3: (O)pções - Options

Explore all possible solutions:

1. **Generate options by asking**:
   - Can we do something to make the problem disappear entirely?
   - What's the simplest possible solution? (even if manual)
   - What solves 80% with 20% of the effort?
   - How easy is it to revert each option?

2. **Research similar solutions**:
   - Use **codebase-pattern-finder** to find similar implementations in the codebase
   - Use **thoughts-analyzer** to see how similar problems were solved before
   - Consider both automated and manual options

3. **For each option, document**:
   - High-level approach
   - Steps involved
   - Error handling strategy
   - Notes on complexity/risks

4. **Present options**:

   ```
   I've identified [N] possible approaches:

   ## Option 1: [Name]
   **Approach**: [Brief description]
   **Steps**: [High-level steps]
   **Error handling**: [What happens when things go wrong]
   **Notes**: [Complexity, dependencies, risks]

   ## Option 2: [Name]
   ...

   Which options seem most promising? Should I explore others?
   ```

### Step 4: (B)alanceamento - Trade-off Analysis

Analyze trade-offs for the most promising options:

1. **For each viable option, analyze**:
   - What do we gain vs what do we lose?
   - How well does this scale?
   - What's the maintenance cost?
   - What are the risks?

2. **Create comparison**:

   ```
   ## Trade-off Analysis

   ### Option: [Name]

   **Gains**:
   - [Benefit with explanation]
   - [Benefit with explanation]

   **Losses**:
   - [Trade-off with explanation]
   - [Trade-off with explanation]

   **Scalability**: [How this grows with load]
   **Maintenance**: [Long-term cost]
   **Risk assessment**: [Potential issues]

   ---

   Based on the trade-offs, which option aligns best with our goals and constraints?
   ```

3. **Get user decision** on preferred approach

### Step 5: (E)xecução - Execution Plan

Create concrete execution steps:

1. **Define execution plan**:
   - What's the first concrete step today?
   - How do we know it worked?
   - What's Plan B?

2. **Break down into phases**:

   ```
   ## Execution Plan

   ### Decision
   We're moving forward with: [Chosen option]

   ### Validation Strategy
   We'll know it works when: [Success criteria]

   ### Implementation Steps

   1. **[Owner]** - [First concrete action]
   2. **[Owner]** - [Next action]
   3. **[Owner]** - [Next action]

   ### Plan B
   If this doesn't work: [Fallback approach]

   ### Timeline
   - [Milestone]: [Date]
   - [Milestone]: [Date]
   ```

### Step 6: Write RFC Document

Once all sections are complete:

1. **Determine filename**:
   - Format: `YYYY-MM-DD-rfc-brief-description.md`
   - Example: `2025-01-30-rfc-subscription-access-handling.md`
   - Location: `thoughts/rfcs/` or `specs/`

2. **Write complete RFC** using this template:

````markdown
# RFC: [Title]

**Author**: [Name]
**Date**: [YYYY-MM-DD]
**Status**: Proposed | Accepted | Implemented | Rejected

## (P)roblema

### What is the real problem vs the symptom?

[Clear description of the actual problem]

### What happens if we DON'T solve this?

[Impact and consequences]

### Why is this a problem NOW?

[Urgency and timing context]

## (R)estrições

### Timeline

[How much time do we have and why]

### Systems/APIs to integrate

[External dependencies]

### Non-negotiables

[What cannot be compromised]
- Correctness: [Requirements]
- Performance: [Requirements]
- Security: [Requirements]
- UX: [Requirements]

## (O)pções

### Option 1: [Name]

**Approach**: [Brief description]

**Steps**:
1. [Step]
2. [Step]
3. [Step]

**Error handling**: [Strategy]

**Notes**: [Additional context]

### Option 2: [Name]

[Similar structure]

## (B)alanceamento

### [Chosen Option Name]

**What we gain**:
- [Benefit]
- [Benefit]

**What we lose**:
- [Trade-off]
- [Trade-off]

**Scalability**: [Analysis]

**Maintenance cost**: [Analysis]

**Risk assessment**: [Risks and mitigations]

## (E)xecução

### Decision

We are implementing: [Chosen option with brief rationale]

### Success Criteria

We'll know this worked when:
- [Measurable outcome]
- [Measurable outcome]

### Implementation Plan

1. **[Owner]** - [Concrete action]
2. **[Owner]** - [Concrete action]
3. **[Owner]** - [Concrete action]

### Plan B

If this approach fails: [Fallback strategy]

### Timeline

- [Milestone]: [Target date]
- [Milestone]: [Target date]

## References

- [Related ticket/issue]
- [Related documentation]
- [Related code: file:line]
````

3. **Present the RFC location**:

   ```
   I've written the complete RFC at:
   `thoughts/rfcs/YYYY-MM-DD-rfc-description.md`

   The RFC documents:
   - Clear problem definition
   - All constraints
   - Options considered
   - Trade-off analysis
   - Concrete execution plan

   Would you like me to refine any section?
   ```

## Important Guidelines

1. **Be Thorough**:
   - Research the codebase before making assumptions
   - Document all options, not just the obvious ones
   - Include manual options as valid choices
   - Consider "do nothing" as an option when relevant

2. **Be Interactive**:
   - Work through each PROBE section sequentially
   - Get user feedback at each stage
   - Don't skip ahead without completing current section
   - Allow course corrections

3. **Be Practical**:
   - Focus on concrete, actionable steps
   - Include error handling for each option
   - Document Plan B for execution
   - Consider maintenance and scale

4. **Be Honest**:
   - Document trade-offs clearly
   - Don't hide downsides
   - Acknowledge when you don't know something
   - Present multiple perspectives

5. **Use Research Tools**:
   - Spawn parallel research tasks to gather context
   - Read relevant files fully
   - Find similar patterns in the codebase
   - Check for past decisions in thoughts/

## Example Interaction Flow

```
User: /write_rfc
Assistant: I'll help you write an RFC using the PROBE framework...

User: We need to handle subscription cancellations better. Users lose access immediately but should keep it until the end of the paid period.
Assistant: [Researches codebase and asks PROBE questions...]

[Interactive process through all 5 sections...]

Assistant: I've written the complete RFC at thoughts/rfcs/2025-01-30-rfc-subscription-access-handling.md
```

## Tips for Success

- Work through PROBE sections **sequentially** - don't skip ahead
- Use research tools to ground decisions in codebase reality
- Document **all** options considered, even ones you reject
- Be explicit about trade-offs - there's no perfect solution
- Include concrete next steps with owners in Execution
- Always have a Plan B
