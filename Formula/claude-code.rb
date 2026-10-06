class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.291"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.291/claude-darwin-arm64.tar.gz"
      sha256 "607c5d79f8f686413b62afce147a3d0ea2fced8ed644b55acfc93a090e3e1f66"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.291/claude-darwin-x64.tar.gz"
      sha256 "041a44e44b5e03adea19887340eb67b41fbc8e3dd1eb4863d5a5b29656eafd90"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.291/claude-linux-arm64.tar.gz"
      sha256 "1ce69c65b35fbc306240afd706d1f910c4e3b8583b88ec3dbdc85bb7a2334222"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.291/claude-linux-x64.tar.gz"
      sha256 "aa196be551bf50e484ae662c5ccecd5ef15fe5b169a1325d64802dcc6755f9bb"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
