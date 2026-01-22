/**
 * UserPromptSubmit Matcher for coder agent (v2.0)
 *
 * The coder agent is an expert implementation agent specializing in pragmatic,
 * production-grade code. It handles direct coding tasks across React, Laravel,
 * and Python/FastAPI stacks.
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
    'implement',
    'write code',
    'build',
    'create',
    'fix bug',
    'add feature',
    'refactor'
  ];

  // Count matching keywords
  const matchCount = keywords.filter((keyword) => prompt.includes(keyword)).length;

  // IMPORTANT: All fields are MANDATORY and must not be undefined/null
  return {
    version: '2.0',
    matchCount: matchCount,
    type: 'agent'
  };
};
