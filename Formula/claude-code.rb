class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.308"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.308/claude-darwin-arm64.tar.gz"
      sha256 "e05000c2f5194208379b025df141e4f286ada8b3151fd7c1876d2a339ecf8fa3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.308/claude-darwin-x64.tar.gz"
      sha256 "3fda4561145b340ee679b0bb06dfc3cc67e1aebda802829c112c91cc2fc078ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.308/claude-linux-arm64.tar.gz"
      sha256 "196b868da6b7c1105c55aa44f3d99c1f7d1325559940924dca92da9e4c6f12a0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.308/claude-linux-x64.tar.gz"
      sha256 "6a699c7205d3c5f99e03a21d6b0511366f41c9a7284547b6e0785504ebdb261a"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
