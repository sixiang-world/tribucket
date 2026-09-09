class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.266"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.266/claude-darwin-arm64.tar.gz"
      sha256 "0fef53e10206aa3e819f0c156313ac67574c1d9be44355f3587c1f08688df4e5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.266/claude-darwin-x64.tar.gz"
      sha256 "4391769450d2f4935e5503aee98dcd7863bcbd293838031dc241d1ea5dbc9f26"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.266/claude-linux-arm64.tar.gz"
      sha256 "88b299b5854d00a2788131d312f06c436fac5e58a014e06c7566587d759bb4f8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.266/claude-linux-x64.tar.gz"
      sha256 "80e04708880470c6d566a414fbc55c52059631feb7cc54537d1d4b39786b20d9"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
