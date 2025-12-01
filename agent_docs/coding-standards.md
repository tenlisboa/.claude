# Coding Standards

Standards enforced by coder and qa-code-reviewer agents.

## Architecture Principles

- **Domain-Driven**: Use business vocabulary in code naming
- **Composition over Inheritance**: Prefer props/composition over class inheritance
- **Decoupling**: Minimize dependencies, use dependency injection
- **Clear Contracts**: TypeScript interfaces for all props and public methods
- **Fail Fast**: Validate inputs immediately, crash early on invalid state

## React Standards

- Functional components only (no classes)
- Use fragments (`<>...</>`) to avoid DOM pollution
- Destructure props for readability
- Limit prop drilling to 2 levels, then use Composition or Context
- Custom hooks for duplicated logic
- Minimal useEffect usage
- Memoize expensive operations (React.memo, useCallback)

## Backend Standards

- Service delegation for business logic (thin controllers)
- Use interfaces for polymorphism
- Document time/space complexity for non-trivial operations

## State Management

1. Stateless by default
2. Keep state co-located with usage
3. Lift state only when necessary
4. Global state as last resort (Auth, Theme only)
5. Never mutate state directly

## Security

- External config for API endpoints, feature flags, credentials
- Sanitize dynamic HTML (DOMPurify)
- Validate URLs and inputs against XSS/injection

## QA Review Criteria

### Critical (Must Fix)
- Error handling: No swallowed exceptions, fail-fast
- Contract integrity: Functions deliver exactly what promised
- Concurrency: No race conditions, proper synchronization
- State: No uncontrolled global mutable state

### Important (Should Fix)
- Single Responsibility: One reason to change
- Coupling: Dependencies flow correctly
- Duplication: No repeated logic
- Change Flexibility: No hardcoded assumptions

### Suggestions
- Domain language usage
- Over-engineering detection
- Inheritance vs composition
- Naming clarity
- Performance awareness
