class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.204"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.204/claude-darwin-arm64.tar.gz"
      sha256 "34efddc551da05cf4d53eb062eeb051a1da44bc7fc981472df35c7cb0af2382d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.204/claude-darwin-x64.tar.gz"
      sha256 "d13910619b922251b5244a820aa4e942ce5dce854d6d56297e974c74bf7123e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.204/claude-linux-arm64.tar.gz"
      sha256 "cb6d5fd4d19b4d7d88b2feeeab04860dab57c24d70897decc5f7148622e5c744"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.204/claude-linux-x64.tar.gz"
      sha256 "f85e3e6540f558da27a6b73a07fc3092ac94269a996d03e3ba0d48279786ad61"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
