class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.172"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.172/claude-darwin-arm64.tar.gz"
      sha256 "36ca7c80ffe1f7c951598121de33bc10488c64e6460c0b544769e27f8bde8247"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.172/claude-darwin-x64.tar.gz"
      sha256 "633f969426c7695b9509efe1443815d78c7467837a1de7f822191d6b9f80c40f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.172/claude-linux-arm64.tar.gz"
      sha256 "68d8cbf79f13c0480fa00d0ca28094e782cb248b22b709aad685ef43e3ac50f0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.172/claude-linux-x64.tar.gz"
      sha256 "b39757eb052ae65d2e06d8c34a0f425970f3c0aa66f70bb3d74204535e308143"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
