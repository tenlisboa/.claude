---
description: Create and open a pull request following repository template with branch verification
---

# Open Pull Request

You are tasked with creating and opening a pull request using the GitHub CLI, following the repository's PR template if available.

## Parameters:

- `target_branch` (optional): Name of the branch to merge into (e.g., `main`, `develop`, `staging`)
  - If not provided as argument, user will be asked to specify it
  - Can be passed as a command argument: `/open_pr main` or `/open_pr develop`

## Steps to follow:

1. **Verify branch context:**
   - Get current branch: `git rev-parse --abbrev-ref HEAD`
   - Check if current branch is main/master: if yes, inform user that PR cannot be created from main branch
   - Verify the repository is a git repository

2. **Determine target branch:**
   - If target branch provided as argument, use it
   - If no argument provided, ask user: "Qual é o branch de destino? (What is the target branch?)"
   - List available branches to help user choose: `git branch -r | grep -v HEAD`
   - Verify target branch exists in the repository: `git rev-parse --verify {target-branch}`
   - If branch doesn't exist, inform user and ask to select from available branches

3. **Verify branch differences:**
   - Check if current branch is different from target: `git diff --quiet {target-branch}...HEAD`
   - If no differences exist, inform user there are no changes to create a PR from
   - If differences exist, proceed to next step
   - Show user the diff summary: `git diff --stat {target-branch}...HEAD`

4. **Check for PR template:**
   - Look for PR template file in `.github/` directory:
     - `.github/pull_request_template.md`
     - `.github/PULL_REQUEST_TEMPLATE/` directory with multiple templates
   - If template exists, read and show it to user
   - If no template exists, ask user: "Qual deve ser o formato da descrição do PR? (Which format should the PR description follow?)"
     - Offer suggestions: detailed changelog, simple summary, checklist format, etc.

5. **Gather PR information from user:**
   - Ask for PR title (in Brazilian Portuguese by default unless user specifies otherwise)
   - Ask for PR description, following the template format if available
   - Ask if PR should be a draft: `gh pr create --draft` (yes/no)
   - Ask for reviewers to assign (optional)
   - Ask for labels to add (optional)

6. **Verify remote repository:**
   - Check for default remote: `gh repo view 2>/dev/null`
   - If error about no default remote, instruct user: `gh repo set-default` and select repository
   - Get remote URL and target base branch info

7. **Create the PR:**
   - Build gh pr create command with collected information:
     ```bash
     gh pr create \
       --title "{title}" \
       --body "{description}" \
       --base {target-branch} \
       [--draft] \
       [--reviewer {reviewers}] \
       [--label {labels}]
     ```
   - Execute the command and capture PR number and URL

8. **Confirm PR creation:**
   - Show user the PR URL and number
   - Ask if user wants to open PR in browser: `gh pr view {number} --web`
   - Suggest next steps: describe-pr command to fill in comprehensive description

9. **Post-creation guidance:**
   - If template exists, remind user to fill in any sections not yet completed
   - If description format was user-defined, suggest using `/describe_pr` command for comprehensive description
   - Remind user that PR should be reviewed before merging

## Important notes:

- Default language is Brazilian Portuguese for prompts and UI, unless user explicitly requests English
- Always verify branches exist and have differences before creating PR
- Do not create PR from main/master branch - this prevents accidental PRs to main
- Show diff summary to user so they can confirm changes before PR creation
- If PR template exists, follow it strictly; if not, ask user preference
- Handle authentication errors gracefully and guide user to authenticate with `gh auth login`
- Preserve template format exactly if one exists - don't modify or simplify
- Always work with the current branch - don't switch branches

## Error handling:

- If not in a git repository: inform user and exit
- If no remote is configured: instruct user to set up remote or use `gh repo set-default`
- If authentication fails: guide user to authenticate with GitHub
- If branches don't have differences: inform user and ask if they want to proceed anyway
- If target branch doesn't exist: ask user to select from available branches
