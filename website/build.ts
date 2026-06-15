/**
 * website/build.ts — Static site builder for tribucket.hunluan.space
 *
 * Reads packages/*.json and README.md, injects data into the HTML template,
 * and copies Formula/*.rb + bucket/*.json into dist/.
 *
 * Usage: bun run website/build.ts
 */

import { existsSync, mkdirSync, cpSync, readdirSync, readFileSync, writeFileSync, rmSync } from "node:fs";
import { join, resolve, dirname } from "node:path";

// Paths
const ROOT = resolve(import.meta.dir, "..");
const DIST = join(ROOT, "dist");
const TEMPLATES_DIR = join(ROOT, "website", "templates");
const STYLES_DIR = join(ROOT, "website", "styles");
const PACKAGES_DIR = join(ROOT, "packages");
const FORMULA_DIR = join(ROOT, "Formula");
const BUCKET_DIR = join(ROOT, "bucket");
const CHANGELOG_PATH = join(ROOT, "CHANGELOG.md");
const VERSION_PATH = join(ROOT, "src", "version.ts");

interface PackageInfo {
  name: string;
  repo: string;
  description: string;
  homepage: string;
  license: string;
}

// ── Helpers ──

function readVersion(): string {
  const src = readFileSync(VERSION_PATH, "utf-8");
  const m = src.match(/VERSION\s*=\s*['"]([^'"]+)['"]/);
  return m ? m[1] : "unknown";
}

function readPackages(): PackageInfo[] {
  const files = readdirSync(PACKAGES_DIR).filter((f) => f.endsWith(".json"));
  const pkgs: PackageInfo[] = [];
  for (const f of files) {
    try {
      const raw = JSON.parse(readFileSync(join(PACKAGES_DIR, f), "utf-8"));
      pkgs.push({
        name: raw.name || f.replace(".json", ""),
        repo: raw.repo || "",
        description: raw.description || "",
        homepage: raw.homepage || "",
        license: raw.license || "",
      });
    } catch {
      console.warn(`[warn] skip invalid package: ${f}`);
    }
  }
  pkgs.sort((a, b) => a.name.localeCompare(b.name));
  return pkgs;
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
      const titleMatch = headerLine.match(/^(.+?)(?:\s*[—–-]\s*(.+))?$/);
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

function copyDirRecursive(src: string, dest: string): void {
  if (!existsSync(src)) {
    console.warn(`[warn] source dir does not exist: ${src}`);
    return;
  }
  mkdirSync(dest, { recursive: true });
  const entries = readdirSync(src);
  for (const entry of entries) {
    const srcPath = join(src, entry);
    const destPath = join(dest, entry);
    const stat = existsSync(srcPath);
    if (stat) {
      cpSync(srcPath, destPath, { recursive: true });
    }
  }
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

  // 2. Read packages
  const packages = readPackages();
  console.log(`  packages: ${packages.length}`);

  // 3. Read and parse CHANGELOG.md
  const changelogSource = existsSync(CHANGELOG_PATH) ? readFileSync(CHANGELOG_PATH, "utf-8") : "";
  const changelog = parseChangelog(changelogSource);
  console.log(`  changelog: parsed`);

  // 4. Read HTML template
  const template = readFileSync(join(TEMPLATES_DIR, "index.html"), "utf-8");

  // 5. Inject data into template
  const html = template
    .replace(/\{\{VERSION\}\}/g, version)
    .replace("{{PACKAGES_JSON}}", JSON.stringify(packages))
    .replace("{{CHANGELOG}}", changelog);

  // 6. Write output files
  writeFileSync(join(DIST, "index.html"), html, "utf-8");
  console.log(`  wrote: dist/index.html`);

  // 7. Copy styles
  mkdirSync(join(DIST, "styles"), { recursive: true });
  cpSync(join(STYLES_DIR, "main.css"), join(DIST, "styles", "main.css"));
  console.log(`  wrote: dist/styles/main.css`);

  // 8. Copy Formula/*.rb
  copyDirRecursive(FORMULA_DIR, join(DIST, "Formula"));
  const formulaCount = existsSync(FORMULA_DIR) ? readdirSync(FORMULA_DIR).filter(f => f.endsWith(".rb")).length : 0;
  console.log(`  copied: Formula/ (${formulaCount} files)`);

  // 9. Copy bucket/*.json
  copyDirRecursive(BUCKET_DIR, join(DIST, "bucket"));
  const bucketCount = existsSync(BUCKET_DIR) ? readdirSync(BUCKET_DIR).filter(f => f.endsWith(".json")).length : 0;
  console.log(`  copied: bucket/ (${bucketCount} files)`);

  // 10. Copy packages/*.json (software source for the CLI)
  copyDirRecursive(PACKAGES_DIR, join(DIST, "packages"));
  const pkgJsonCount = existsSync(PACKAGES_DIR) ? readdirSync(PACKAGES_DIR).filter(f => f.endsWith(".json")).length : 0;
  console.log(`  copied: packages/ (${pkgJsonCount} files)`);

  console.log(`\n  ✓ Build complete: dist/`);
}

main();
