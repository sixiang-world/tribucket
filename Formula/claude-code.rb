class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.318"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.318/claude-darwin-arm64.tar.gz"
      sha256 "cd7fa988d60e7aef7ed453847650255138440b229d081496b8ed0ab75836603b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.318/claude-darwin-x64.tar.gz"
      sha256 "ea3e05371b9e8760e5d366529db9c6a96d968f5d1a41ba42ad61687c9a3f8173"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.318/claude-linux-arm64.tar.gz"
      sha256 "0f4fb66a2af3bf02d114099727e4a7745f117b1e63d2f77c8aff165590197421"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.318/claude-linux-x64.tar.gz"
      sha256 "e6d426ca0c123f61fad58a361da0329f2a93cd206bc87040ed8d9576dd9eb583"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
