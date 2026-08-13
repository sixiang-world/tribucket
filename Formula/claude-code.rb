class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.229"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.229/claude-darwin-arm64.tar.gz"
      sha256 "41c4526e0f8fb1f14df3c939832af1a645fa1ff4859714342d125a9dbbbde06c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.229/claude-darwin-x64.tar.gz"
      sha256 "e8f7477fe1cb50eeb10c31cb9701cdc26375140be08e5e33ee75f25f952dbe19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.229/claude-linux-arm64.tar.gz"
      sha256 "89ba26ba3f622f849115e2f8abcfe326abf1b2b4272523002c8de223d753fa95"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.229/claude-linux-x64.tar.gz"
      sha256 "ec8052503d2a7afa8cdc9cf664c3634696e66a5088708c2cc477a5d35fba77fd"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
