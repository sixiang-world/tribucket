class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.325"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.325/claude-darwin-arm64.tar.gz"
      sha256 "b0dc23f2d8c3ef55b2b22f03ef204e98b06b22b6c51a15b66d263b13442c4e03"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.325/claude-darwin-x64.tar.gz"
      sha256 "ea9d1cf6cc3284450208f0e7045849022b6da558000d6f0699d96515f0fd2a0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.325/claude-linux-arm64.tar.gz"
      sha256 "2abe2bea8b802190a303f335b0fd09f95eb775457e99df5a4778b09dfab6bbd6"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.325/claude-linux-x64.tar.gz"
      sha256 "9686b0fb1eefbd7f2cc1f53f932516c29cd605e9d976223323a6c6e9a4c9c7fe"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
