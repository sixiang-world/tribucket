class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.257"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.257/claude-darwin-arm64.tar.gz"
      sha256 "4ca35800ac8cf42e9c134b6bb9253edd65174379f46050c915af119fe15d8534"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.257/claude-darwin-x64.tar.gz"
      sha256 "70acd9af85bf96c75397e04024b343389ec256d261e054838e2ca853c4164873"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.257/claude-linux-arm64.tar.gz"
      sha256 "db8c858191bf9fb9f0e394aa72b591a15e51d13f2c86ae3f141a4c5820e3124f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.257/claude-linux-x64.tar.gz"
      sha256 "d9e18dc3742ab9c65de0ece30d11b8721ed7c98748ecbf030a63e4d0a5f68a78"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
