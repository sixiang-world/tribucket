class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.260"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.260/claude-darwin-arm64.tar.gz"
      sha256 "c333c99bc4eb8e3d10685afb3ba0c5b7be7864f1b702575f2c6d145bfe370329"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.260/claude-darwin-x64.tar.gz"
      sha256 "d90b015e49ef293e4e0587fcaf4c3da71a56fa023cf03c42f6fbf995a40b288a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.260/claude-linux-arm64.tar.gz"
      sha256 "cf0fc1c67da1db2b11384eed574360adb7aa29445da295a19d1a67901f998ae5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.260/claude-linux-x64.tar.gz"
      sha256 "85c098eb76ef7476e7d6c7b813a8a4a42c3c95656947809166102067f5a3d551"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
