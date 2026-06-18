class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.181"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.181/claude-darwin-arm64.tar.gz"
      sha256 "9dc9378ea9c1fa1a0246a5c8c2dd6a3caff9d6343cc42267c19fc1d78bfecf61"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.181/claude-darwin-x64.tar.gz"
      sha256 "c2127c29d07c89b605a19583db8ed738f6ab0915a52182c12bd8564ea37e58c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.181/claude-linux-arm64.tar.gz"
      sha256 "8ef60ada7ffa2f0a14b5256ccad580f05ad3d07cba408476a4e3be199b083650"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.181/claude-linux-x64.tar.gz"
      sha256 "90cfbea83460714bad716742c0484a4835b521843aac1d5c4f246ed2c0b027a0"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
