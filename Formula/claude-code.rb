class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.281"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.281/claude-darwin-arm64.tar.gz"
      sha256 "874a9df33b44a040273cce0cd4ed615a713491b1e51ae1ece6ee6c3bffa98e16"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.281/claude-darwin-x64.tar.gz"
      sha256 "260b5767791ac01b0f82b920b23486068549ce870413a150c05dec05ffbb25bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.281/claude-linux-arm64.tar.gz"
      sha256 "f4ffa7230f09882977b1195a5f5343fea1443027858d1c1fa1ea82e921517cd0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.281/claude-linux-x64.tar.gz"
      sha256 "0a3d25f34f0a733fe23f34ecde87dc5bdebd2ccc457fb2d446ae33d6eb75f3d7"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
