class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.319"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.319/claude-darwin-arm64.tar.gz"
      sha256 "7ae10919ce40346befabe3c18da4d5ccc860201b6785b3ae726d8961472d0e5d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.319/claude-darwin-x64.tar.gz"
      sha256 "e8c5ff7094a30964808485dd31eddfe954ee4f6dc5ac9aed4a35caed3598a4ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.319/claude-linux-arm64.tar.gz"
      sha256 "2e7348ffc96d52ccb20e34c81240ebc92505edc84d7bf29182d62c29bf6fa066"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.319/claude-linux-x64.tar.gz"
      sha256 "8cf226393c8eca446d6ca60fa6bbe3fa7b5fa4de82a7b410d1edbd48689cd776"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
