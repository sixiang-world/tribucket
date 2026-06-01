class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.159"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.159/claude-darwin-arm64.tar.gz"
      sha256 "03eda0290e28d7a63687f85cd50beed15d08b2236bf4044e6dc07e1dbd65d548"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.159/claude-darwin-x64.tar.gz"
      sha256 "b985e788c43bb86ab850314416667eaffaa12416aa4c5a09905155f01b00ca20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.159/claude-linux-arm64.tar.gz"
      sha256 "d7e31278f07f734c17c26e6b3f43482e5717d76ce1bc538ae7b4b72bffba7010"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.159/claude-linux-x64.tar.gz"
      sha256 "d25a2af365254113c5dbb35b75073bd7bdc04dc18fead6cbd92f1402fcdcf4bc"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
