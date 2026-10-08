class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.294"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.294/claude-darwin-arm64.tar.gz"
      sha256 "2adac5f74f236d434d42e1e24a7d68591269f229c987aff19d9ef7e61eee405b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.294/claude-darwin-x64.tar.gz"
      sha256 "967358670cad3b8d164cd681ac704e1141ece51e8a44781f6992f79a93f25e73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.294/claude-linux-arm64.tar.gz"
      sha256 "a4be2509f5ad94b4a1c490ce0dd0a3fffa2825d1047f69979c0c9d7b4c913aa8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.294/claude-linux-x64.tar.gz"
      sha256 "c152a9520cbe30adfaa7dbff26016d74c668c7dfb093fca2a06fa72cb6e98369"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
