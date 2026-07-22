class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.217"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.217/claude-darwin-arm64.tar.gz"
      sha256 "fdb30ef5a0c58bfa3ff64c65c42dc1ccb3ae9dc115121c575dd74e6da39b7a29"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.217/claude-darwin-x64.tar.gz"
      sha256 "be868be4f67586f5b1f36f7c0e157a548d8ca2c9ab1106f2a4ae95f15e9bdb6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.217/claude-linux-arm64.tar.gz"
      sha256 "5321a9c4c013faacfb60e70ebd66c43cfd060db9b652a298b3843429aea022b1"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.217/claude-linux-x64.tar.gz"
      sha256 "31af12d3b7cc8f2d3854bbf11e4283068b5a946d143160c0f9fa8b7e9c907d40"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
