class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.202"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.202/claude-darwin-arm64.tar.gz"
      sha256 "3fda22aad8c6d6053775a0b172277ddca777149b743d52c0043a431049ce98e8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.202/claude-darwin-x64.tar.gz"
      sha256 "4997d53a197eaddabdbe9e289e7d66fb21fa9399505da93902996e39e2f10ddf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.202/claude-linux-arm64.tar.gz"
      sha256 "cac56544b25ecc599f62087359c58fe9aa615f8dd22e4ac40c3574eadc39e9e5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.202/claude-linux-x64.tar.gz"
      sha256 "f76320526e43d44ded691d2b0a3d39b59a51585fa4691f3cde6181b56ee60fef"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
