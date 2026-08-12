class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.228"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.228/claude-darwin-arm64.tar.gz"
      sha256 "a6f728b1d481ec66fef01c2c6a4ceab6b2f29affe51417f830bb24196d2098ce"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.228/claude-darwin-x64.tar.gz"
      sha256 "62440994f8f214cfaa9b162cc6930ddb5d9a21012dbfda71ab749bbcc0f1f3ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.228/claude-linux-arm64.tar.gz"
      sha256 "877d423c35e6d059752f86399352837df5bf1af2a9dbcda5753d898629a439f4"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.228/claude-linux-x64.tar.gz"
      sha256 "9050d667bcc3940b7ceee65e3e5c4439d2b7161a71d940fdf60192302243f960"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
