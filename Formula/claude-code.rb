class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.304"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.304/claude-darwin-arm64.tar.gz"
      sha256 "bb2fb10066e34c67facad46bf94d47e72c4d808a7a23590224544ee4b4aadaea"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.304/claude-darwin-x64.tar.gz"
      sha256 "7c98406983c5a96c95c7a8b456c49def8324cbdde28e5aa002bbca0e838ca190"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.304/claude-linux-arm64.tar.gz"
      sha256 "17cc5d933babad064bed65b3a4fbafab29556fbbfc12aa7888ae1f6c320e08c5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.304/claude-linux-x64.tar.gz"
      sha256 "ea6ae29e6eea7dd35d4b05a5a1db5a040a0b294c5ab7d0f7fa299db9b6e625c0"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
