/**
 * website/build.ts — Static site builder for tribucket.hunluan.space
 *
 * Reads CHANGELOG.md and src/version.ts, injects into the HTML template.
 * Package data (packages/*.json, Formula/*.rb, bucket/*.json) is served
 * at runtime via EdgeOne KV + Edge Functions — not baked into the build.
 *
 * Usage: bun run website/build.ts
 */

import { existsSync, mkdirSync, cpSync, readFileSync, writeFileSync, rmSync } from "node:fs";
import { join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

// Paths
const ROOT = resolve(fileURLToPath(new URL("..", import.meta.url)));
const DIST = join(ROOT, "dist");
const TEMPLATES_DIR = join(ROOT, "website", "templates");
const STYLES_DIR = join(ROOT, "website", "styles");
const CHANGELOG_PATH = join(ROOT, "CHANGELOG.md");
const VERSION_PATH = join(ROOT, "src", "version.ts");

// ── Helpers ──

function readVersion(): string {
  const src = readFileSync(VERSION_PATH, "utf-8");
  const m = src.match(/VERSION\s*=\s*['"]([^'"]+)['"]/);
  return m ? m[1] : "unknown";
}

/**
 * Parse changelog from CHANGELOG.md.
 * The file uses "## vX.Y.Z — Title" headings for each version.
 */
function parseChangelog(changelog: string): string {
  const trimmed = changelog.trim();
  if (!trimmed) {
    return '<li class="changelog-item"><div class="changelog-version">暂无更新日志</div></li>';
  }

  // Split by "## " version headings, then drop any chunks whose first line
  // isn't a version heading (e.g. the document's H1 title "# 更新日志").
  const parts = trimmed
    .split(/\n##\s+/)
    .map((p) => p.trim())
    .filter((p) => p && /^v?\d/i.test(p));
  if (parts.length === 0) {
    return '<li class="changelog-item"><div class="changelog-version">暂无更新日志</div></li>';
  }

  return parts
    .map((part) => {
      const lines = part.trim().split("\n");
      // First line: version + optional tag
      const headerLine = lines[0].trim();
      const titleMatch = headerLine.match(/^(.+?)(?:\s*(?:—|–|-)\s*(.+))?$/);
      const version = titleMatch ? titleMatch[1].trim() : headerLine;
      const tag = titleMatch && titleMatch[2] ? titleMatch[2].trim() : "";

      // Rest: bullet points
      const bullets = lines
        .slice(1)
        .filter((l) => l.trim().startsWith("- "))
        .map((l) => {
          const text = l.trim().slice(2).trim();
          // Convert **bold** to <strong>
          return "<li>" + text.replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>") + "</li>";
        })
        .join("\n");

      return (
        `<li class="changelog-item">` +
        `<div class="changelog-version">${version}${tag ? `<span class="tag">${tag}</span>` : ""}</div>` +
        (bullets ? `<ul>${bullets}</ul>` : "") +
        `</li>`
      );
    })
    .join("\n");
}

// ── Main ──

function main() {
  console.log(":: tribucket website builder");

  // Clean dist
  if (existsSync(DIST)) {
    rmSync(DIST, { recursive: true });
  }
  mkdirSync(DIST, { recursive: true });

  // 1. Read version
  const version = readVersion();
  console.log(`  version: ${version}`);

  // 2. Read and parse CHANGELOG.md
  const changelogSource = existsSync(CHANGELOG_PATH) ? readFileSync(CHANGELOG_PATH, "utf-8") : "";
  const changelog = parseChangelog(changelogSource);
  console.log(`  changelog: parsed`);

  // 3. Read HTML template
  const template = readFileSync(join(TEMPLATES_DIR, "index.html"), "utf-8");

  // 4. Inject data into template (package data is fetched at runtime from
  //    /api/packages.json via EdgeOne KV — only version + changelog are inlined)
  const html = template
    .replace(/\{\{VERSION\}\}/g, version)
    .replace("{{PACKAGES_JSON}}", JSON.stringify([]))
    .replace("{{CHANGELOG}}", changelog);

  // 5. Write output files
  writeFileSync(join(DIST, "index.html"), html, "utf-8");
  console.log(`  wrote: dist/index.html`);

  // 6. Copy styles
  mkdirSync(join(DIST, "styles"), { recursive: true });
  cpSync(join(STYLES_DIR, "main.css"), join(DIST, "styles", "main.css"));
  console.log(`  wrote: dist/styles/main.css`);

  console.log(`\n  ✓ Build complete: dist/`);
}

main();
