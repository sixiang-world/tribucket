class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.289"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.289/claude-darwin-arm64.tar.gz"
      sha256 "20acfc89a32ed7260b63fd2f3fd71a33de7b2d74b82c724d25941ad73d2e0e96"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.289/claude-darwin-x64.tar.gz"
      sha256 "6cef9fa7347447c8f8a025bde024f21f457dad118e3a955da978d285ce5e762e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.289/claude-linux-arm64.tar.gz"
      sha256 "f1dd579805a35402555a833dde1ee509ff6744921dd3f706c82831c7b31cd65f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.289/claude-linux-x64.tar.gz"
      sha256 "aa184fe26777b16e18230da937ffe369e40f261bc65405520cafd7bd95783bef"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
