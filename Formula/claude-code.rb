class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.296"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.296/claude-darwin-arm64.tar.gz"
      sha256 "60f97cde7f7e078b424138e34ecf1ad620bd81ac3866984fb8996623a36a052e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.296/claude-darwin-x64.tar.gz"
      sha256 "3851a1f6a6a28870615e2b76bc0e85af020b9ac7d6b71c9e6f2b35817a012451"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.296/claude-linux-arm64.tar.gz"
      sha256 "c644ad3e5ca3367e75d198194189d13180f33c491304c2d19557f7c1e8d5e0a6"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.296/claude-linux-x64.tar.gz"
      sha256 "45fe2b33f5cbdd114309618970bcd90b8b163e34252d66cf100d7e068d9b831d"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
