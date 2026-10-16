class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.301"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.301/claude-darwin-arm64.tar.gz"
      sha256 "f25bc45464024006c042b0342b5f0afea4eab949d56c53cc9513a29900f510e2"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.301/claude-darwin-x64.tar.gz"
      sha256 "97c8b191c17b69f3431681fa93581737e7420577a2ebbf5df031a6536d15c8c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.301/claude-linux-arm64.tar.gz"
      sha256 "a19875467f8125449a39ebe0467e11b04be8a3130e100783043fc281ef6ed4a3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.301/claude-linux-x64.tar.gz"
      sha256 "40d2cbbd74a43e9ed683c9f8f93afdadeed09d16d56095fe1e46dedaa1728082"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
