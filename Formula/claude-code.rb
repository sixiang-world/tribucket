class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.243"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.243/claude-darwin-arm64.tar.gz"
      sha256 "074b129845e2daebcc7b8ac4b12226bde61e2d702e758d8dd0309b21ff50204d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.243/claude-darwin-x64.tar.gz"
      sha256 "00b1a77e1b399dc73c1ce1bd22d0df1545bea1233a11f7ef9b0f65a263e5c75b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.243/claude-linux-arm64.tar.gz"
      sha256 "533b3c79d7a4716ce7f8fceca40acbb14ed9fcd3726402b6e5d9c441a00f3ca3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.243/claude-linux-x64.tar.gz"
      sha256 "2682e73eb64b136a1d714558b7ce9ff6f052bf90458ba057f11881fed4f3eaa8"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
