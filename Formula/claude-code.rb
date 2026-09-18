class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.277"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.277/claude-darwin-arm64.tar.gz"
      sha256 "2e512ad5a7e6769e2455e9dc4a4b01ff5f4cb1ed0bcb919a400901119cfbc34c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.277/claude-darwin-x64.tar.gz"
      sha256 "48fe292cc3462f6f7f6a3945a647b14a38589336305bd71edb1189b19096a077"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.277/claude-linux-arm64.tar.gz"
      sha256 "e912430cc2dc16e15bc34cb86622bbf2f3a6a3e4d0753e73ef38325ce9fecfba"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.277/claude-linux-x64.tar.gz"
      sha256 "6ade0a13de4a1967a4ed6b72a4485a028b3d86c9f8873317b12acee5f92aca99"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
