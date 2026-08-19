class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.235"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.235/claude-darwin-arm64.tar.gz"
      sha256 "d1254b3f786b71e619d20dd831e35678ce0b3bbc16ece57db6fa8ccb90c53349"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.235/claude-darwin-x64.tar.gz"
      sha256 "de2eba31be18fdd8b15345df67e15b1d3eb9a7beb2196c3f97d26ace38085e5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.235/claude-linux-arm64.tar.gz"
      sha256 "dcf18dda361ee62337d0a0cc4a91fd9b110c5bef79fade41cd862de344fa58b7"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.235/claude-linux-x64.tar.gz"
      sha256 "22c0c8a3fe6cc592eb5368b2bd6fea1b66bce0e915b853fa12841907bee348e8"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
