class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.314"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.314/claude-darwin-arm64.tar.gz"
      sha256 "c819253fa84c46ee77e14afb1aab0c38d7fdb240d914d168e9ad2e21ce3ba1b4"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.314/claude-darwin-x64.tar.gz"
      sha256 "b323d782325f71825b14189ccb6663ca772ca90fab95bc79b2e365b29f82234b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.314/claude-linux-arm64.tar.gz"
      sha256 "6acfc0d2f965bf910f12e89da32cc2bc826974e555d50c4a4b0936e042ec749b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.314/claude-linux-x64.tar.gz"
      sha256 "348a302629f3734a2a7318a97eb6a05d4c30e772f9c8366cb78a55977eca46da"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
