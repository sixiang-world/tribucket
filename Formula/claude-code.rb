class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.168"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.168/claude-darwin-arm64.tar.gz"
      sha256 "e80e963103ef243a4704cac920c617cd116a023e083984728d409042e21a6d44"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.168/claude-darwin-x64.tar.gz"
      sha256 "08c26fd84c6ce19e87bf9f5e1a9c83db638f05d15031cfd8f24e02ea99c74c2d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.168/claude-linux-arm64.tar.gz"
      sha256 "3b1776e953651f6a3c58d2f5b40857c7642b6625bd715a7785a0b615cbeb09e7"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.168/claude-linux-x64.tar.gz"
      sha256 "17662901d95c7e4ded4df43de0a4378cfeae8cb397b22fb7002e90c8d4ec1aa5"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
