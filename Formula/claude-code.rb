class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.215"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.215/claude-darwin-arm64.tar.gz"
      sha256 "599883973d2b4c8bb25e3490c84d65646f78d158cdc86adc73c1f5a6cfbbd600"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.215/claude-darwin-x64.tar.gz"
      sha256 "e51307bf3f98e0fdc6a452ab425409657d14e0c255184898db44ea3cf9eab44b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.215/claude-linux-arm64.tar.gz"
      sha256 "16279120e232ad9e97a5377232dd45b1f375ea917bf37205a5419c2919a36432"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.215/claude-linux-x64.tar.gz"
      sha256 "fbbecf88a9f2c397c07f0d1568d55e0dba346983836252492144ff389ab5729d"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
