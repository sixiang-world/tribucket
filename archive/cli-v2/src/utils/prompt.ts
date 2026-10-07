/**
 * src/utils/prompt.ts — Interactive confirmation prompt
 *
 * Reads from stdin to ask the user for confirmation (y/N).
 * Skips automatically when stdin is not a TTY (piped input).
 */

import { createInterface } from 'readline';

/**
 * Ask the user for confirmation.
 *
 * @param question  The prompt text (without trailing space/punctuation).
 * @returns `true` if confirmed, `false` if denied or non-TTY.
 */
export async function confirm(question: string): Promise<boolean> {
  // If --yes was passed globally, skip prompt and return true.
  if (process.env.TRIBUCKET_YES === '1') return true;
  // In non-TTY mode (piped input), skip the prompt and return false.
  if (!process.stdin.isTTY) return false;

  const rl = createInterface({
    input: process.stdin,
    output: process.stderr,
  });

  return new Promise((resolve) => {
    const timer = setTimeout(() => {
      rl.close();
      resolve(false); // timeout = reject
    }, 30000);
    rl.question(`${question} [y/N] `, (answer) => {
      clearTimeout(timer);
      rl.close();
      resolve(answer.trim().toLowerCase().startsWith('y'));
    });
  });
}
