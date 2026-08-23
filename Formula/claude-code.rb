class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.241"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.241/claude-darwin-arm64.tar.gz"
      sha256 "439a69a041f68a282c01fb8268b1743cf6ea03deef34e71a8f55e33e2288e6ca"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.241/claude-darwin-x64.tar.gz"
      sha256 "3184842d2377e071514c38aa0c1e162f701f9ebc045b79f3e6004b24d367771f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.241/claude-linux-arm64.tar.gz"
      sha256 "d3563afb0328eee644b5b830c3de42699b56a0d83de3423a466a0e2065b2417d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.241/claude-linux-x64.tar.gz"
      sha256 "c171011648d71b96a0956469a46315a4c826ccba7e20854ae62aa5c776d6a794"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
