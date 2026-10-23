class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.309"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.309/claude-darwin-arm64.tar.gz"
      sha256 "09a74f9e0493ebea7e8867565ae04c8989575e6ef1d0a84e3b392c8065284395"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.309/claude-darwin-x64.tar.gz"
      sha256 "12a9e671ac54b4d3fdb5a8e5ff94a94c5d2f08eb5fa481c2ccc3da5446a84657"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.309/claude-linux-arm64.tar.gz"
      sha256 "8ecd1f2d06ccbd3f89c8886e840e42b57a19063f3de9cfe5f7d90fe875ba99ef"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.309/claude-linux-x64.tar.gz"
      sha256 "6259b381b9501b0b2b5d3ce4c068595bf32a59f1ca131ed69a1b1ae25b891cad"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
