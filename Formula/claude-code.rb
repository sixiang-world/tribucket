class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.280"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.280/claude-darwin-arm64.tar.gz"
      sha256 "872a1fa1f770165202bfa0e1771a8b02ce0a13b5f6de4f4489ec4ff268946b56"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.280/claude-darwin-x64.tar.gz"
      sha256 "96c54208699e555f67da028f12d7ab594b6bbb844b5d65b47640c086c65ad959"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.280/claude-linux-arm64.tar.gz"
      sha256 "e6cdd9f07fba8d181b7d6d0dedd9406f1be6ba4f5302a56a61ab4ebb43c5a569"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.280/claude-linux-x64.tar.gz"
      sha256 "4239c476881f46f5bd2cccee97c10b1c8073f4ab4ae40e3c829493210e757764"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
