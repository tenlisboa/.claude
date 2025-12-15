/**
 * UserPromptSubmit Matcher for qa-code-reviewer Agent (v2.0)
 *
 * Triggers when user requests code review, analysis, or quality assessment.
 * This agent performs rigorous systematic reviews focusing on maintainability,
 * reliability, and architectural soundness.
 *
 * IMPORTANT: All return fields are MANDATORY and must not be undefined/null.
 *
 * @param {Object} context - Matcher context
 * @param {string} context.prompt - User's prompt text
 * @param {string} context.cwd - Current working directory
 * @param {string} context.transcriptPath - Path to conversation transcript
 * @param {string} context.permissionMode - "ask" | "allow"
 * @param {string} context.sessionId - Session ID
 * @param {Object} context.meta - Meta information
 * @param {Object} context.transcript - Transcript utilities (for async usage)
 * @returns {Object} Matcher result with all required fields
 */
module.exports = function (context) {
  const prompt = context.prompt.toLowerCase();

  const keywords = [
    'review',
    'code review',
    'check for issues',
    'audit',
    'analyze',
    'examine',
    'refactor',
    'improve architecture',
  ];

  // Count matching keywords
  const matchCount = keywords.filter((keyword) => prompt.includes(keyword)).length;

  // IMPORTANT: All fields are MANDATORY and must not be undefined/null
  return {
    version: '2.0', // Required: always "2.0"
    matchCount: matchCount, // Required: number of matches (0+)
    type: 'agent', // qa-code-reviewer is an agent
  };
};
