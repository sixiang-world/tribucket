class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.299"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.299/claude-darwin-arm64.tar.gz"
      sha256 "dd2579ba8cf89b58bb57228ba26546ac070fec981d0ceed33754f1a3911787aa"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.299/claude-darwin-x64.tar.gz"
      sha256 "cb3b4d1402944ddb91a4e066b738239328d72efdd9e58e0fef34e74e2646a607"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.299/claude-linux-arm64.tar.gz"
      sha256 "d77bc1bc624c429f3e7d28d4ca93c4c9ce9e079264f1ab313daa6b59d1cdb18f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.299/claude-linux-x64.tar.gz"
      sha256 "053ff263ea005565625d8e94e15a1beb3b0dc46f7578ba15984c9ab9e17137be"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
