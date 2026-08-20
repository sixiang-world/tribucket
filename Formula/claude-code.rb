class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.237"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.237/claude-darwin-arm64.tar.gz"
      sha256 "cc5c73476727d8a8232eab949c19e3cd1ada2a3e51767b954eccd1ab752c9563"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.237/claude-darwin-x64.tar.gz"
      sha256 "9850f5507a99596cf3f96bb33e6eb6f1478eb0f1063a97e9b72858aebdaca576"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.237/claude-linux-arm64.tar.gz"
      sha256 "aa99b5672ec5ac1ba0e5536ab4cab23df0080022df25ae0b84e8a678dbbabe5a"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.237/claude-linux-x64.tar.gz"
      sha256 "fe1c47e3309c731b6c9b382599603df3784b00d65a2236f46c867fc55436adfa"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
