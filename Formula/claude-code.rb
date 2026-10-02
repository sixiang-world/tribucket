class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.288"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.288/claude-darwin-arm64.tar.gz"
      sha256 "86616c1bdb2d3581343b41bf1674b936991d74d14b6d5cf205194cd7d2e104fe"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.288/claude-darwin-x64.tar.gz"
      sha256 "d5181f0842894b6a495e97bc4f0215556ee224b9a8a27b6e7fc3c340dea9e08e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.288/claude-linux-arm64.tar.gz"
      sha256 "4d27054191394530666025db88114ea38c31cc5f5564766beb909b079a9652c4"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.288/claude-linux-x64.tar.gz"
      sha256 "5f3e0d5bfc21123a880ba6ffbd10f1b819c5e56204473591be1c1f65847c9368"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
