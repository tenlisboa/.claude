/**
 * UserPromptSubmit Matcher for qa-code-reviewer Agent (v2.0)
 *
 * Detects when users request code review, quality assurance, or
 * quality feedback on implementation work.
 */
module.exports = function (context) {
  const prompt = context.prompt.toLowerCase();

  const keywords = [
    'review code',
    'code review',
    'review',
    'audit',
    'analyze code',
    'check for issues',
    'feedback',
    'refactor',
  ];

  // Count matching keywords
  const matchCount = keywords.filter((keyword) => prompt.includes(keyword)).length;

  // IMPORTANT: All fields are MANDATORY and must not be undefined/null
  return {
    version: '2.0',
    matchCount: matchCount,
    type: 'agent',
  };
};
