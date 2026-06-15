/**
 * Compile-time build flags injected via Bun's --define.
 *
 * Set during CI build:
 *   bun build --define DEBUG_BUILD=true
 *
 * When undefined (default release build), the runtime falls back to
 * environment variables for debug/diagnostic behavior.
 */
declare const DEBUG_BUILD: boolean | undefined;
