class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.239"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.239/claude-darwin-arm64.tar.gz"
      sha256 "11b0375d108137a5b408e97c7a9f5933362599a414572ac886d7b5e5f905ca1e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.239/claude-darwin-x64.tar.gz"
      sha256 "cf3b9cd9fb1fabcb4d6cfe134c90f09e3727667cc486b30495f8573bc24cf036"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.239/claude-linux-arm64.tar.gz"
      sha256 "a52a69daa1db8814351fc2135d37ad236b10706bbdd33c7085f0f3bbc562c4fb"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.239/claude-linux-x64.tar.gz"
      sha256 "b3931fba48a309b241a39f997de9b13f5047c11f438c3f4e120e248e21dbef88"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
