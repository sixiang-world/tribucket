class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.222"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.222/claude-darwin-arm64.tar.gz"
      sha256 "e934dad3d95d914664764107885e45a37e4c95be65fd452b00d3191b0f63d427"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.222/claude-darwin-x64.tar.gz"
      sha256 "19dbebebb225df69659d6d2d2337e58457a8b3dd817fc80c26dec60a9123d4c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.222/claude-linux-arm64.tar.gz"
      sha256 "68c8d31e3cf81d4e0f608900c866b8bb2f0e2645e89d0917ce8a23f2ec277587"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.222/claude-linux-x64.tar.gz"
      sha256 "40d531b4c125f3e70aa3cc6da489e7138d63866758be06cc5797d1b5d78f50f3"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
