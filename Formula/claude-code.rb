class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.316"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.316/claude-darwin-arm64.tar.gz"
      sha256 "e8956064b1c5055c1c79945aa7714faef98b29060a065c6930e8956953d0bace"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.316/claude-darwin-x64.tar.gz"
      sha256 "7265a50837056d5b4f90985610228ea3fba6fa0a457dd499d22ff6ff905b34c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.316/claude-linux-arm64.tar.gz"
      sha256 "5f82c7fd9f289c9aad37792ffa5ca1bcd40d6dd3298b3a36ce01179e12ab2b14"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.316/claude-linux-x64.tar.gz"
      sha256 "9ca14cd81a7b0d9654d392fc1253773e70f31f470aa98334732744956cd1006b"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
