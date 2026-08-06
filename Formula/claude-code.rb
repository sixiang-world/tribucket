class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.223"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.223/claude-darwin-arm64.tar.gz"
      sha256 "bde87a9ca03aab749f749c56abecbe15e427fe4a9fe51df8548ad7a3ac664d69"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.223/claude-darwin-x64.tar.gz"
      sha256 "f752b3ff70aaf4a2a9f854f404084ee3f180dc6d3b667c3a37090b41351d86cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.223/claude-linux-arm64.tar.gz"
      sha256 "e6a7ce80f57317c9121d429fe2bcc7b5b82cd901863c3f33754589dcc99d0460"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.223/claude-linux-x64.tar.gz"
      sha256 "0b516307190edfb776501e5c12a32d7d0c0b01d1110fa6539fd187a8482ad24f"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
