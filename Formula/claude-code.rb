class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.179"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.179/claude-darwin-arm64.tar.gz"
      sha256 "0137d8dbc95d3a993dc74580ad4c3bd3a187c526882af05d0b5d6b0462fdafe3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.179/claude-darwin-x64.tar.gz"
      sha256 "80cee5f1bb773aa8171174816ed2cd9f430dd16a5568db8e0254d66368245bb9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.179/claude-linux-arm64.tar.gz"
      sha256 "2439f35a1520c4ff9fb8748893db53cbeb25e98cee3882cea7d8774ca3e978bb"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.179/claude-linux-x64.tar.gz"
      sha256 "ab2332560769f1717ec215f4737d19445f251fb7ccee2de0207a129eccf52e21"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
