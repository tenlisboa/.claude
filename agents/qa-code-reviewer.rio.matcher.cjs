/**
 * UserPromptSubmit Matcher for qa-code-reviewer Agent (v2.0)
 *
 * Triggers when user requests code review, quality analysis, or verification.
 * Delegates to qa-code-reviewer agent for systematic code quality assessment.
 *
 * Keywords: review code, code review, review, analyze, quality, architecture, verify, check for issues
 */
module.exports = function (context) {
  const prompt = context.prompt.toLowerCase();

  const keywords = [
    'review code',
    'code review',
    'review',
    'analyze',
    'quality',
    'architecture',
    'verify',
    'check for issues',
  ];

  const matchCount = keywords.filter((keyword) => prompt.includes(keyword)).length;

  return {
    version: '2.0',
    matchCount: matchCount,
    type: 'agent',
  };
};
