class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.263"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.263/claude-darwin-arm64.tar.gz"
      sha256 "c41b084242538dc94adb60b9cc74dab7571e1eb1d51ac7fb6c60fa9f16531765"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.263/claude-darwin-x64.tar.gz"
      sha256 "459314a8bd2116f69cbd78caaa7c2d03f966a3aeaa7ffb6327f1f5f9e7d3b83a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.263/claude-linux-arm64.tar.gz"
      sha256 "cba2e616346c4f45f7fe468297bcc186d84ee6c292b2b1814b9be190b1da49be"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.263/claude-linux-x64.tar.gz"
      sha256 "7f1444a22ba7c0949b728a19511ed8e47d218ab23b32dbb0a557fe9798ad7ce6"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
