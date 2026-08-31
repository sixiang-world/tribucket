class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.252"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.252/claude-darwin-arm64.tar.gz"
      sha256 "5ec54c876c2088052e78a04205543a33c7c232ad5b075d46f639955f963432f8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.252/claude-darwin-x64.tar.gz"
      sha256 "550fb44377f72e6b2eb3deb8631402c68174f563dfb3fe1c0f6482ccdd6f9f11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.252/claude-linux-arm64.tar.gz"
      sha256 "fb9db286c4ff00d1d17e139ead18ef17ba6f0ad9ae1dd29f6f568dac23206220"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.252/claude-linux-x64.tar.gz"
      sha256 "ec803faf88d1e9087c2b59e6833150d1c09dc9dda5c5b7941c50e1482e81b909"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
