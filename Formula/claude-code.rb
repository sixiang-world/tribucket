class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.322"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.322/claude-darwin-arm64.tar.gz"
      sha256 "0ff389f1a313f50778c2472c2f85882ca82c10156398c68cfc3c332004694646"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.322/claude-darwin-x64.tar.gz"
      sha256 "7a7291c5ae01c8f8e91dc2636da43f905bd3cb52b1170229850f83f3fef194e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.322/claude-linux-arm64.tar.gz"
      sha256 "65c1ad35e804ef463f34585d0c080afd4bf2e9018c7bad1f29efb8df4e9c3750"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.322/claude-linux-x64.tar.gz"
      sha256 "3d2bc5ae54d4d4cd63510e9fcca5b6d48d2b18806708df8c8f691aa486c5dca8"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
