class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.227"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.227/claude-darwin-arm64.tar.gz"
      sha256 "e030ca0636f72b89e65dc918ea860960a60a7a63632e68550b9fd5b0af8dabab"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.227/claude-darwin-x64.tar.gz"
      sha256 "7126f4f4e211f349ab00315430557dbdb1f2dab58fff9691351d9d9597ecbe65"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.227/claude-linux-arm64.tar.gz"
      sha256 "e998df163821c7c2be66139f0b5411e26928b9bc18326edb95576b7bc94168b3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.227/claude-linux-x64.tar.gz"
      sha256 "ee91648d1c54b978594d43ac1b2c4a83083215c6f609a437cd9cb4da3811ee55"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
