---
description: Create Jira ticket and PR for experimental features after implementation
---

you're working on an experimental feature that didn't get the proper ticketing and pr stuff set up.

assuming you just made a commit, here are the next steps:

1. get the sha of the commit you just made (if you didn't make one, read `.claude/commands/commit.md` and make one)

2. create a jira ticket using the atlassian MCP tools:
   - use ToolSearch to load jira tools if not already available
   - use `mcp__plugin_atlassian_atlassian__getAccessibleAtlassianResources` to get cloudId
   - use `mcp__plugin_atlassian_atlassian__getVisibleJiraProjects` to list available projects
   - think deeply about what you just implemented
   - create the ticket with `mcp__plugin_atlassian_atlassian__createJiraIssue`:
     - summary: concise title of what was implemented
     - description: should have "### Problem to Solve" and "### Proposed Solution" sections in markdown
     - issueTypeName: typically "Task" or "Story" (check project metadata if unsure)
   - transition the ticket to "In Progress" using:
     - `mcp__plugin_atlassian_atlassian__getTransitionsForJiraIssue` to get available transitions
     - `mcp__plugin_atlassian_atlassian__transitionJiraIssue` to move to in-progress state

3. use the jira issue key (e.g., PROJECT-123) from the created ticket for the branch name
4. git checkout main
5. git checkout -b 'feat/ISSUEKEY-brief-description' (e.g., 'PROJ-123-add-auth-feature')
6. git cherry-pick 'COMMITHASH'
7. git push -u origin 'BRANCHNAME'
8. gh pr create --fill
9. read '.claude/commands/describe_pr.md' and follow the instructions
