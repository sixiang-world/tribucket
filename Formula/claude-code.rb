class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.248"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.248/claude-darwin-arm64.tar.gz"
      sha256 "73775e892ac428b4575b618156de173778c3df9afc4c2cc64dbb746e69beed93"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.248/claude-darwin-x64.tar.gz"
      sha256 "613f8a84de540e060bd87bc08afd93530d42f896d3df99ef234fa98bd7ca2269"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.248/claude-linux-arm64.tar.gz"
      sha256 "ec6423ef338c68b25962cde11d075625afcdd4e46d118f6d423d3c0534ea2df6"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.248/claude-linux-x64.tar.gz"
      sha256 "9baff38eabf5d7a5d57917c312a00654953ed3ece87680bda090c8743ffaa619"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
