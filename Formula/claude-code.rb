class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.278"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.278/claude-darwin-arm64.tar.gz"
      sha256 "d16dc23a4e27155a59cdc35251eccd7fa30ed46482c51af1c33e71b14d790f6b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.278/claude-darwin-x64.tar.gz"
      sha256 "d5fa59ea628b85b0a9d4b2c8aa59a20a9b9714a0b08c938b2d04de1f00c07bb2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.278/claude-linux-arm64.tar.gz"
      sha256 "5e3cc367f997847c89cdba3f5b1cd6ff5aabb8e94e14b19bad401124c0e838ed"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.278/claude-linux-x64.tar.gz"
      sha256 "1d1f9950b96acb5a50bf342a3d3bd51cdf40b1714b2ca3ce2319ba8e8e7f3633"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
