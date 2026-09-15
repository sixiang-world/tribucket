class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.272"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.272/claude-darwin-arm64.tar.gz"
      sha256 "3254b8926b112e5af92dbb9c3840fb33187678c9638807e31f7f9b100bc8c6d5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.272/claude-darwin-x64.tar.gz"
      sha256 "f37f6b1550eae8a26754df6250d4e57c3edd382bb726c865d04564d18ce8d984"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.272/claude-linux-arm64.tar.gz"
      sha256 "e9c157be5f0855a895a7f0fd56f81b27c1c21a005bbb6174ccbb00cca0503a06"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.272/claude-linux-x64.tar.gz"
      sha256 "acc3cefd4db54379e309568c122a6a99a10f4662187bbc3698d3d00bc599ad2e"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
