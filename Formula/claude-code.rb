class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.245"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.245/claude-darwin-arm64.tar.gz"
      sha256 "53d05686bce02a96fb7912e33237cace60ec9149ad5a512ec26f1865679b16b5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.245/claude-darwin-x64.tar.gz"
      sha256 "bcacd81dca568ae10a129e993f896f19e8b75c0016b9e130499f905e6cf99e5a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.245/claude-linux-arm64.tar.gz"
      sha256 "ec08af5c412a4456f200c20e586e0268eda62fac7952fe14ff97f0aab485c7b6"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.245/claude-linux-x64.tar.gz"
      sha256 "7a0875ca6f73f82ffb8cd4679bbd2771d8a397eb864dadb6e26faed2a4ebb342"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
