/**
 * UserPromptSubmit Matcher for /post-init command (v2.0)
 *
 * Matches prompts requesting CLAUDE.md optimization using HumanLayer best practices.
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
    'optimize',
    'claude.md',
    'post-init',
    'best practices',
    'progressive disclosure',
    'why/what/how',
    'humanlayer',
    'agent_docs',
  ];

  const matchCount = keywords.filter((keyword) => prompt.includes(keyword)).length;

  return {
    version: '2.0',
    matchCount: matchCount,
    type: 'command',
  };
};
