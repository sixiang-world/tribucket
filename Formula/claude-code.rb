class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.220"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.220/claude-darwin-arm64.tar.gz"
      sha256 "1c895d3d7a97cc1ebd457a2f64ba20212476de82468e4a3fc142beeee270e55e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.220/claude-darwin-x64.tar.gz"
      sha256 "3c9072239f05fdd4ca6a02a58d892f2ccf0460ff7e5c94a9c88d65eb3383da16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.220/claude-linux-arm64.tar.gz"
      sha256 "a4f2e93621b1521731d1f132c83f8266384403ab29e14986d67e3b4a805bf454"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.220/claude-linux-x64.tar.gz"
      sha256 "e69e7f72d784c243bcc377a578ad9ff8e65ae14da672fbbf9f2ba7bf47eca7ec"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
