class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.193"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.193/claude-darwin-arm64.tar.gz"
      sha256 "1a50f65adc16f6e0f2d80bb1a1ec951e05081465165a868436092ec83ada3b8f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.193/claude-darwin-x64.tar.gz"
      sha256 "50d17752955f91778bc63f4a88e41e9ed6366801bf8a2ec14d23b292fdc97b3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.193/claude-linux-arm64.tar.gz"
      sha256 "1094bc938ea396e945695dc3d08f89b6cbdd31677db48a3856a64e86f451a63e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.193/claude-linux-x64.tar.gz"
      sha256 "7553990c7ad2f3453b8bbf560870c8272db7b984b052d9b24960aede086637be"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
