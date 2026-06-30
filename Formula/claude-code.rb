class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.197"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.197/claude-darwin-arm64.tar.gz"
      sha256 "f616402f87c278c9dc9297e703afd1b21144f4c4b28cd45d1e2ccdc89eaf9e03"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.197/claude-darwin-x64.tar.gz"
      sha256 "0026de494be024f5b3c4230a95f28eb5ad745bd4c1c0063556727d54b11f7699"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.197/claude-linux-arm64.tar.gz"
      sha256 "d3f1b79e9ca56b2a3eb7861dbf77d94e1bb9aa5e25aeba5ab5b1888c86c92cab"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.197/claude-linux-x64.tar.gz"
      sha256 "4996733b19143a484e70d21d7ecf8576207306006d1f5b5fa976ee5f60c60dff"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
