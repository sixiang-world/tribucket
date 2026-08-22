class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.240"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.240/claude-darwin-arm64.tar.gz"
      sha256 "53ea8602d595d4d2049343662545b6e229f511525a3b4cc6fe622c1df4355b2a"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.240/claude-darwin-x64.tar.gz"
      sha256 "a8719428db64fb88762259733a1e5a5f0e7120c062dcc024fc8e627257c33637"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.240/claude-linux-arm64.tar.gz"
      sha256 "d2cac755f002ef706b3aadc33152aca90712c26db9d465c7f2bcf53830ee96ce"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.240/claude-linux-x64.tar.gz"
      sha256 "91f9d997ad676002f7eacbc33a1579772d57583041f92e50f656e6a8360bcebc"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
