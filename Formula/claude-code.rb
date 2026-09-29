class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.285"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.285/claude-darwin-arm64.tar.gz"
      sha256 "3b1c9984a63193c7758b66c8769781428139935200c38e6462339cf4da463d78"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.285/claude-darwin-x64.tar.gz"
      sha256 "8cab1b4d2b6f3aeb4f4f5ed99f6fb4a51ef6198f4d8deffe6c4a835c4bdb5c09"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.285/claude-linux-arm64.tar.gz"
      sha256 "39bd977cb57144ba41ad165e4cca540e9b4b58199df79dd96fa7002be7086923"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.285/claude-linux-x64.tar.gz"
      sha256 "0cde844749a50c0f717a2b123d5771629d5c9a270c9203c81ac120a716444b36"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
