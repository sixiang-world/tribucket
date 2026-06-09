class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.169"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.169/claude-darwin-arm64.tar.gz"
      sha256 "8f9b9b4e21e0fc8222a611f8b4676121d357c38f593d5fdce023f8da4452b04b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.169/claude-darwin-x64.tar.gz"
      sha256 "127116cfc1635657a7ef1ec14096ddd049f72b0ef901dfe9caf8372b6c230d1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.169/claude-linux-arm64.tar.gz"
      sha256 "a2f9cd9a8217b08683f561d363062a1e75abb9748e78065fb7c7f07af7325a0d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.169/claude-linux-x64.tar.gz"
      sha256 "5f2f778a460823505947b3fec932575907b614f67dc8f134d5d273e6f9252995"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
