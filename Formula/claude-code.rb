class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.196"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.196/claude-darwin-arm64.tar.gz"
      sha256 "c05c3c71c89f413c3ee6677ac2e7946b3c8c0d118206e4f889d47602a24cf4c7"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.196/claude-darwin-x64.tar.gz"
      sha256 "b3cef9415924261a9f0b6cb11d7ec7df3373bd075b076373df04c2af1797c3a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.196/claude-linux-arm64.tar.gz"
      sha256 "f67d395bd640beb4df4d24c8d5be3852526284977d5645a02b2fcb425d527422"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.196/claude-linux-x64.tar.gz"
      sha256 "6ebd818a3957cd7ccbfb2b24f67e0a9063f94b86db6233e0dd33f483c5bc52ed"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
