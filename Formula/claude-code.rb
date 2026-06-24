class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.190"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.190/claude-darwin-arm64.tar.gz"
      sha256 "f9adc4638ce59b5fc10b426c17710df9635cb6122e2265aff740e86d63735449"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.190/claude-darwin-x64.tar.gz"
      sha256 "fecbd9e5b54c39191373a1101019c61208503a657de7195584b74c22fc5aee95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.190/claude-linux-arm64.tar.gz"
      sha256 "b47d4de5f69f81e4947f795dc7279fdad4a54db1a7baf773c72fb9664a837850"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.190/claude-linux-x64.tar.gz"
      sha256 "84d635550344c5e13e669bda6c3422edb836bf73e29dc279e0394fb048c648c2"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
