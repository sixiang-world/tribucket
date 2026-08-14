class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.232"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.232/claude-darwin-arm64.tar.gz"
      sha256 "21ddc57d85e86eeee81a1837be3f2965d6e7d320fff1e0286fb20fde23c8be9c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.232/claude-darwin-x64.tar.gz"
      sha256 "14d1c2bee52c4e692668435acf7a26a0163f2e7fbe568dd31aa94d1dd9f96c00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.232/claude-linux-arm64.tar.gz"
      sha256 "be301c2058d43aa69658283d3d0578a1a12c81b40355e1490320f3091c6e1f44"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.232/claude-linux-x64.tar.gz"
      sha256 "89c50fab379391bb511f14ce2e8fd0812a58d332376c3d952beca99b70700655"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
