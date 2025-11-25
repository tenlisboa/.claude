---
description: Analyze and fix bugs from stacktraces/error messages in Python, PHP Laravel, and React applications
argument-hint: "<paste your error/stacktrace here>"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
model: claude-sonnet-4-5
---

# 🔍 Debug Application Error

Analyze the provided error/stacktrace and provide a comprehensive fix.

## Error/Stacktrace Provided

```
$ARGUMENTS
```

## Analysis Workflow

### Step 1: Automatic Stack Detection

Analyze the error format to identify the technology:

**Python indicators:**

- Traceback format: `Traceback (most recent call last):`
- File paths: `.py` extensions
- Error types: `TypeError`, `ValueError`, `AttributeError`, `ImportError`, `RuntimeError`
- Framework signatures: Django, FastAPI, Flask error patterns

**Laravel/PHP indicators:**

- Error format: `ErrorException`, `FatalErrorException`
- File paths: `.php` extensions, `app/`, `vendor/laravel/`
- Stack format: `#0`, `#1`, `#2` numbering
- Framework signatures: Eloquent, Illuminate components

**React/JavaScript indicators:**

- Error format: `Error:`, `TypeError:`, `Uncaught`
- File paths: `.js`, `.jsx`, `.ts`, `.tsx` extensions
- Stack format: `at ComponentName`, `at functionName`
- Framework signatures: React component names, hook errors

### Step 2: Error Classification

Classify the error into categories:

**Syntax/Import Errors:**

- Missing imports/requires
- Typos in function/class names
- Incorrect syntax

**Runtime Errors:**

- Null/undefined references
- Type mismatches
- Missing properties/methods

**Logic Errors:**

- Incorrect conditions
- Wrong function arguments
- State management issues

**Configuration Errors:**

- Missing environment variables
- Database connection issues
- Misconfigured services

### Step 3: Context Gathering

Based on detected stack, gather relevant files:

```bash
# Read the files mentioned in stacktrace
# Check recent changes to those files
git diff HEAD~5 -- <affected-files>

# Look for related configuration
# Check test files
# Review documentation/comments
```

### Step 4: Root Cause Analysis

**For Python:**

1. Examine the full traceback (start from the bottom)
2. Check variable types and values at error point
3. Review imports and module structure
4. Check for async/await issues
5. Verify database/external service connections

**For Laravel:**

1. Check the full stack trace from `storage/logs/laravel.log`
2. Review the controller/model methods involved
3. Verify database queries (check for N+1 issues)
4. Check route definitions and middleware
5. Review validation rules and request data
6. Check service provider bindings

**For React:**

1. Identify the component causing the error
2. Check component lifecycle and hooks
3. Review props and state at error point
4. Check for missing dependencies in useEffect
5. Verify event handlers and callbacks
6. Check for key prop issues in lists

### Step 5: Solution Implementation

Provide:

1. **Explanation** of what caused the error
2. **Code fix** with the exact changes needed
3. **File locations** where changes should be made
4. **Verification steps** to confirm the fix

### Step 6: Prevention Recommendations

Suggest:

- Linting rules to catch similar issues
- Type checking improvements
- Error handling additions
- Tests to prevent regression

## Stack-Specific Debugging Commands

### Python

```bash
# Run the failing code with full traceback
python -u script.py

# Use debugger
python -m pdb script.py

# Check imports
python -c "import module_name"

# Run with verbose logging
PYTHONVERBOSE=1 python script.py

# Check type hints
mypy --strict file.py
```

### Laravel

```bash
# Check detailed logs
tail -f storage/logs/laravel.log

# Test in Tinker
php artisan tinker

# Debug routes
php artisan route:list | grep <route-name>

# Check database connection
php artisan db:show

# Clear all caches
php artisan optimize:clear

# Run failing queue job
php artisan queue:work --tries=1 --verbose
```

### React

```bash
# Run with source maps
GENERATE_SOURCEMAP=true npm start

# Check console with verbose errors
REACT_APP_DEBUG=true npm start

# Type check
npx tsc --noEmit

# Lint specific file
npx eslint src/components/Component.tsx

# Run specific test
npm test -- Component.test.tsx
```

## Output Format

````
# 🐛 Debug Report

## Stack Detected
[Python/Laravel/React]

## Error Summary
[One-line description of the error]

## Root Cause
[Detailed explanation of why this error occurred]

## Files Affected
- `path/to/file.ext` (line X)
- `path/to/related.ext` (line Y)

## Fix Implementation

### File: `path/to/file.ext`
```[language]
// Before (lines X-Y)
[current code]

// After
[fixed code]
````

**Explanation:** [Why this fix works]

### File: `path/to/related.ext` (if needed)

[Additional changes]

## Verification Steps

1. [Step to test the fix]
2. [Expected outcome]
3. [Additional checks]

## Prevention Strategy

- [ ] Add type checking/validation
- [ ] Add error boundary/handling
- [ ] Add test case
- [ ] Add documentation
- [ ] Update linting rules

## Quick Test Command

```bash
[Command to verify the fix works]
```

```

## Common Error Patterns

### Python

**ImportError: No module named 'X'**
- Check if package is installed: `pip list | grep X`
- Verify requirements.txt
- Check virtual environment activation

**AttributeError: 'NoneType' object has no attribute 'X'**
- Variable is None before accessing
- Add null check or ensure assignment

**TypeError: X() takes N positional arguments but M were given**
- Check function signature
- Verify argument count and types

### Laravel

**QueryException: SQLSTATE[HY000]: General error**
- Check database connection in .env
- Verify migration ran: `php artisan migrate:status`
- Check table/column names

**Class 'X' not found**
- Check namespace and use statements
- Run `composer dump-autoload`
- Verify class is in correct location

**Too few arguments to function**
- Check route parameters
- Verify controller method signature
- Check dependency injection

### React

**Cannot read property 'X' of undefined**
- Add optional chaining: `object?.property`
- Check if data is loaded before rendering
- Add loading state

**Maximum update depth exceeded**
- Remove state updates from render
- Fix infinite useEffect loop
- Check dependencies array

**Objects are not valid as a React child**
- Trying to render object directly
- Use `.map()` or extract primitive value
- Check what's being returned

## When to Use Subagents

If the error is complex or requires deep framework knowledge, consider delegating:

```

"Use the python-debugger subagent to analyze this async/await error"
"Use the laravel-debugger subagent to debug this Eloquent relationship issue"
"Use the react-debugger subagent to fix this hooks dependency problem"

```

## Important Notes

- Always read the FULL stacktrace, not just the last line
- Check for recent code changes that might have introduced the bug
- Verify environment variables and configuration
- Don't assume - verify by reading the actual code
- Test the fix before closing the issue
```
