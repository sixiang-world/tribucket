class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.312"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.312/claude-darwin-arm64.tar.gz"
      sha256 "b5ff41139e79b6ffdabe4df93c09ee628b1306a78be6459139fd7c7f175c85ac"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.312/claude-darwin-x64.tar.gz"
      sha256 "f4378cda8b6c256e36da75b8571971bbfc54f02901855d5c15fae16255e17188"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.312/claude-linux-arm64.tar.gz"
      sha256 "0635c6245b11bbb4ca16e4119b0ac3980ee99e2f8cf5ab6e8d6c0e9e0db3ee5b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.312/claude-linux-x64.tar.gz"
      sha256 "d9324231c4e3dfe342e853f56c752348ae060f9f221cdf4b0f90ef1dc47ee907"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
