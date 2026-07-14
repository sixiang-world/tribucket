class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.208"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.208/claude-darwin-arm64.tar.gz"
      sha256 "d1502db660fc2c618f3bda91d4251259dc20874e1b83586b81cbcaa098f4f183"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.208/claude-darwin-x64.tar.gz"
      sha256 "48a92b386b23cf6736cadb9b7ff404a0a4a13bef5f28dbde086ab0a154952a23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.208/claude-linux-arm64.tar.gz"
      sha256 "584b6f23de0bbf9e80f687b5c1bac5a1341f3986371738b6334a6d75872cb75f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.208/claude-linux-x64.tar.gz"
      sha256 "d7704bcafed279ef8e2a93b0912019fe5d363cfa8ddc6e3749fba4f7f1ba49bd"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
