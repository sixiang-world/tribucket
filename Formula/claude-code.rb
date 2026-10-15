class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.300"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.300/claude-darwin-arm64.tar.gz"
      sha256 "c18b0721712908fbeeb16f5a95338a4968db7f98c3031b684e402f472b923751"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.300/claude-darwin-x64.tar.gz"
      sha256 "dde16153cbf8dadc6c8bb24d612c2ac9c60e79c77d87db3825e6b9af1a9362a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.300/claude-linux-arm64.tar.gz"
      sha256 "7a4164d191334aa63dbbd0c9b77209770438e50eb04cac414cdf44f73c01d2bc"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.300/claude-linux-x64.tar.gz"
      sha256 "11e459c4368a48554d5aa5eabf7f6d84a2ff7ae2f7210795394f60ded6633f56"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
