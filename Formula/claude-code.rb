class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.198"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.198/claude-darwin-arm64.tar.gz"
      sha256 "a8a6292caa74a2be029fd3a1c71dac2ef66c685db554aaca7ed1c6fb306f08e0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.198/claude-darwin-x64.tar.gz"
      sha256 "d6a1ffe622bc26ee6738e77861f41c0edf0c3c461a29f2957fbe00a9be983923"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.198/claude-linux-arm64.tar.gz"
      sha256 "237a09cf85ead6f63302770715b0915fca3bc42e48f3f966ae7303b5f4d07885"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.198/claude-linux-x64.tar.gz"
      sha256 "8a33b9dbb90d8136bbda190cb362d1e9b2fa13e0c1f7a080c56d395924c71daa"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
