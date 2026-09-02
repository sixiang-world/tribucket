class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.258"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.258/claude-darwin-arm64.tar.gz"
      sha256 "c13a3e6373f686f91c3c2d199e0ea6bad67430d2c3325adcc1aafa26d298f655"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.258/claude-darwin-x64.tar.gz"
      sha256 "1de08071cd4245eae799bc7edf313f2a602aa15064dbf8ecc559bb56c3031514"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.258/claude-linux-arm64.tar.gz"
      sha256 "d9d18e4f10efc7521212b1adb34f0a4f4698ebc80be017a371f59c3d206d399a"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.258/claude-linux-x64.tar.gz"
      sha256 "4dcbd239217dd01a5cf73002eea8f85e945170830d66891948426a09c99f3292"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
