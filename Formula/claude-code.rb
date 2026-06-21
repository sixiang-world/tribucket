class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.185"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.185/claude-darwin-arm64.tar.gz"
      sha256 "454a1e5c083b93731b08baf1462c99a10f959e5a289f71dd63467235d9345b2f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.185/claude-darwin-x64.tar.gz"
      sha256 "b6ae2ad515c240127a66fb2740905ca02f3a28feb27caa349c1c45a7b75469c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.185/claude-linux-arm64.tar.gz"
      sha256 "81d5ca5212d14ea247ed574e06393c69b994c3181fed369caebf2ee98ef75bd0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.185/claude-linux-x64.tar.gz"
      sha256 "78da43f740bf99d7847e9e73f3d580c601aa0755fc55c74b4b95e13e68068d50"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
