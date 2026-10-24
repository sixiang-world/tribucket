class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.310"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.310/claude-darwin-arm64.tar.gz"
      sha256 "cf47d30004ff26e5cfed6004a29ca94e05ad53d6f890ee1be8bb582e8ce2a5b5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.310/claude-darwin-x64.tar.gz"
      sha256 "4c62f49341f7d902bb92186d67eee2adbf014faba9ab617729de52d7b719e1c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.310/claude-linux-arm64.tar.gz"
      sha256 "97ab45a42fdb141dc37d3b12973638ebd8fda59163eca51b02aa2eded0630874"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.310/claude-linux-x64.tar.gz"
      sha256 "5bea9e13ac07ea6804c24e6263ec7e5b3d13f81d3f681c92f9784c534425fae1"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
