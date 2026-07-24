class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.219"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.219/claude-darwin-arm64.tar.gz"
      sha256 "f0d662a2fd7817671432bc795c833d7dda8ec5525bbfa5063dd0f2405b72f4e9"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.219/claude-darwin-x64.tar.gz"
      sha256 "62515ee9529aba8ff540343b8bc8239fbb713b6de54406bb288003d5d3a50fa4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.219/claude-linux-arm64.tar.gz"
      sha256 "ff560571fe5a61030d0c370d21261c8a2d83a2e561e6d7420ab0c93abba05889"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.219/claude-linux-x64.tar.gz"
      sha256 "a33b6242b608ff208e8af5c89b13e6720ade7cd46620d62c8402f90e9531cd69"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
