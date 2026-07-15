class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.210"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.210/claude-darwin-arm64.tar.gz"
      sha256 "0d30caeef4dd693b331da31e0e0250e4ca6c5ec811f58ce961c2441d27efb1a2"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.210/claude-darwin-x64.tar.gz"
      sha256 "cb720c25d0eb355c333f9d69e37180a18cee1aef5e47a119d5f95853a1104bb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.210/claude-linux-arm64.tar.gz"
      sha256 "83c01a39c3f785c6ae43c8923d5596e3246e7b87782b4cacc34259fbee5821d8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.210/claude-linux-x64.tar.gz"
      sha256 "3db32c13a1e16b2d867d096a9808f42d8678c5597d10799a1904fd897e043beb"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
