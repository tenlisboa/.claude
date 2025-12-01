# Specification Format

## Template

```markdown
# Feature: [Clear, business-focused title]

## Context
[Summary of codebase investigation - what exists, what patterns to follow]

## User Story
As a [user type]
I want to [capability]
So that [business value]

## MVP Scope

**In Scope:**
- [Essential capability 1]
- [Essential capability 2]

**Deferred:**
- [Nice-to-have 1] → Future iteration
- [Nice-to-have 2] → Future iteration

## Acceptance Criteria

### Scenario: [Happy path use case]
Given [initial context/state]
When [action/trigger]
Then [expected outcome]
And [additional outcomes if needed]

### Scenario: [Edge case]
Given [different context]
When [problematic action]
Then [graceful handling]

### Scenario: [Error condition]
Given [context leading to failure]
When [invalid action]
Then [appropriate error response]

## Non-Functional Requirements
- Performance: [specific, measurable criteria]
- Security: [specific requirements]
- UX: [specific expectations]

## Technical Notes
[Observations from codebase investigation relevant to implementation]

## Success Metrics
- [Measurable outcome 1]
- [Measurable outcome 2]

## Open Questions
- [Any unresolved items requiring user input]
```

## Section Guidelines

### Context

Document what you discovered during codebase investigation:

```markdown
## Context
The application uses FastAPI with SQLAlchemy. Existing user management
lives in `api/routes/users.py` with corresponding models in `models/user.py`.
Authentication uses JWT tokens via the `auth/` module.

Current patterns:
- Pydantic models for request/response validation
- Repository pattern for database access
- Dependency injection for services
```

### User Story

Keep it focused on a single user goal:

**Good:**
```
As a team admin
I want to invite new members via email
So that I can grow my team without manual account creation
```

**Bad (too many goals):**
```
As a team admin
I want to invite members, manage roles, and configure permissions
So that I can fully administer my team
```

### MVP Scope

Be explicit about what's in and out:

```markdown
## MVP Scope

**In Scope:**
- Send email invitation with unique link
- Accept invitation via link
- Basic rate limiting (10 invites/hour)

**Deferred:**
- Bulk invite from CSV → v2
- Custom invitation message → v2
- Invitation expiry configuration → v2
- Invitation templates → Future
```

### Acceptance Criteria

#### Happy Path
The normal, successful flow:

```gherkin
Scenario: User successfully invites team member
Given I am logged in as a team admin
And I have remaining invitation quota
When I enter a valid email address and click "Send Invite"
Then an invitation email is sent to that address
And the invitation appears in my "Pending Invitations" list
And my remaining quota decreases by 1
```

#### Edge Cases
Boundary conditions and unusual states:

```gherkin
Scenario: User invites already-existing member
Given I am logged in as a team admin
And john@example.com is already a team member
When I try to invite john@example.com
Then I see "This user is already a member of your team"
And no invitation is sent

Scenario: User invites with pending invitation
Given I am logged in as a team admin
And there's a pending invitation for jane@example.com
When I try to invite jane@example.com
Then I see "An invitation is already pending for this email"
And I'm offered to resend the existing invitation
```

#### Error Conditions
Invalid inputs and failure modes:

```gherkin
Scenario: User exceeds invitation rate limit
Given I am logged in as a team admin
And I have sent 10 invitations in the past hour
When I try to send another invitation
Then I see "Rate limit exceeded. Try again in X minutes"
And the invitation form is disabled

Scenario: Invalid email format
Given I am logged in as a team admin
When I enter "not-an-email" in the email field
Then I see inline validation error "Please enter a valid email"
And the submit button remains disabled
```

### Non-Functional Requirements

Make them measurable:

**Good:**
```markdown
- Performance: Invitation API responds in <200ms p95
- Security: Invitation tokens expire after 7 days
- Security: Rate limit: 10 invitations per hour per admin
- UX: Email delivered within 30 seconds of request
```

**Bad (vague):**
```markdown
- Performance: Should be fast
- Security: Should be secure
- UX: Should be user-friendly
```

### Technical Notes

Reference actual codebase findings:

```markdown
## Technical Notes
- Use existing `EmailService` in `services/email.py` for sending
- Follow pattern in `models/invite.py` which already has similar structure
- JWT token generation available via `auth/tokens.py:generate_token()`
- Rate limiting can leverage existing `RateLimiter` middleware
- Database migrations should follow existing Alembic pattern
```

### Success Metrics

Define how to measure success:

```markdown
## Success Metrics
- 80% of invitations accepted within 48 hours
- <1% invitation delivery failures
- Zero security incidents related to invitation tokens
- Admin can invite 5 users in under 2 minutes
```

### Open Questions

Track unresolved items:

```markdown
## Open Questions
- Should invitations expire? If so, after how long?
- Can non-admins invite? (Currently assuming no)
- Should we notify admin when invitation is accepted?
```

## Writing Good Scenarios

### Be Specific
```gherkin
# Bad
Given a user
When they do something
Then it works

# Good
Given I am logged in as a team admin with "manage_members" permission
When I submit the invitation form with email "new@example.com"
Then a POST request is sent to /api/invitations
And the response status is 201 Created
And the response includes the invitation ID
```

### Cover State Transitions
```gherkin
Scenario: Invitation state changes on accept
Given an invitation exists for "user@example.com" with status "pending"
When the user clicks the invitation link
And completes the signup form
Then the invitation status changes to "accepted"
And a new user account is created
And the user is added to the team
```

### Include Validation Rules
```gherkin
Scenario: Email validation rules
Given I am on the invitation form
When I enter an email with these characteristics:
  | Input           | Result        |
  | user@domain.com | Valid         |
  | user@domain     | Invalid       |
  | @domain.com     | Invalid       |
  | user@           | Invalid       |
  | user domain.com | Invalid       |
Then validation feedback appears inline
```

### Test Business Rules
```gherkin
Scenario: Only admins can invite
Given I am logged in as a regular team member
When I navigate to /team/invite
Then I am redirected to /team
And I see "You don't have permission to invite members"
```
