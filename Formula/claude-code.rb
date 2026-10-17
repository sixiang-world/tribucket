class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.302"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.302/claude-darwin-arm64.tar.gz"
      sha256 "757a3b11dbd1b6881bb513cc50ab7a7fc03d8b77011dde7687152c3b61cc71f3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.302/claude-darwin-x64.tar.gz"
      sha256 "1f95415b658a290fe9436df85c244ea79586db6f1595928f2e613ac9c9de45d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.302/claude-linux-arm64.tar.gz"
      sha256 "812a10792bf91bccba6de57b86c2ff055264037b99011cfd558db8e6967760c3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.302/claude-linux-x64.tar.gz"
      sha256 "0d865f10fe49f2e731ab9d4f7bdcce082cad4f7bbf71d2cbbf7be47b9d8ae5dc"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
