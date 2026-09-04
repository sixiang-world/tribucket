class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.261"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.261/claude-darwin-arm64.tar.gz"
      sha256 "041fe31aabf7cd5111bc916e5dc0b5b3a2e8d456a0e007b364beaf602f68c265"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.261/claude-darwin-x64.tar.gz"
      sha256 "bc036516e430232cdfe29174bdade8f7f459cffdfc50e0c8db8f9ac8b3d6cdc8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.261/claude-linux-arm64.tar.gz"
      sha256 "40772aed92ae8dafc719c23b58c595e50b5c2dfd006840fa1ba5cd0a21eea107"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.261/claude-linux-x64.tar.gz"
      sha256 "9c798b18618cb6c0ec6e6e7ab56eb338fd6f0f679f372a4d6ed76e1ab95c14a0"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
