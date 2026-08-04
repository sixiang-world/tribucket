class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.221"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.221/claude-darwin-arm64.tar.gz"
      sha256 "1a14ae6e0db980b4bf19d8dce58a1a14219597f926df75a3e0da0ba4d7435189"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.221/claude-darwin-x64.tar.gz"
      sha256 "63b0bf91fe70cab131d9fbc481967a7d8d0e8cc2d4dea61c8d8586d8ff63bda8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.221/claude-linux-arm64.tar.gz"
      sha256 "2d59431c116aec070516fec3dcf3d4e1447a62665aee899eb74b086a1dc7e3c7"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.221/claude-linux-x64.tar.gz"
      sha256 "9b6f16520af4f47622fec82b4b2218645b675adaf39438c87625221f07f5e70f"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
