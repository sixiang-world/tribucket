class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.167"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.167/claude-darwin-arm64.tar.gz"
      sha256 "5cc094a463d02e8b5c2d4ccf414d92a3a20b32a869b5d5639fcbdbd5b08bc2b1"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.167/claude-darwin-x64.tar.gz"
      sha256 "c7677c7819531fb24b855ded1f4f0eee37ef31fd40cf682c0ee07af8c012bc44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.167/claude-linux-arm64.tar.gz"
      sha256 "4ff8a435955814d330b71d19080f45297d9dbccfd2875e613982eb4dc1ff7931"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.167/claude-linux-x64.tar.gz"
      sha256 "0cac5e6e317fa115373c1b27dce53d8bf837602ac1dd3748eb968819fd91d335"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
