class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.214"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.214/claude-darwin-arm64.tar.gz"
      sha256 "cb4ce0a82f89b288f9936562e317c727c34614339188d550f6b3e25217ed4909"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.214/claude-darwin-x64.tar.gz"
      sha256 "aa18b63bd5df2df3a855a63fbaccdcb8c09b1bb0cc540a8e09ffe9e98519e38b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.214/claude-linux-arm64.tar.gz"
      sha256 "528478d4a51d4644f1314f25a3acc136b9ca8cd178f6ecf626ede5a592d3ce77"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.214/claude-linux-x64.tar.gz"
      sha256 "b07fb17dd5226d3cb4413f3ec8ef5be8a2437a70209eae9a1321b7eacece41a1"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
