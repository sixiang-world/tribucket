class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.282"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.282/claude-darwin-arm64.tar.gz"
      sha256 "09e4c31cbd44ddcf95d1157533f3f66fd630da11a8e115f3fc678110cb19ee24"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.282/claude-darwin-x64.tar.gz"
      sha256 "a182bc43e63421f8a89e903d5e3a3eff7cf8a54e8774b05956ccacbc21c9352d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.282/claude-linux-arm64.tar.gz"
      sha256 "62ed261b4ad0838eac468f119524ba58502bc09da8152eddce9194229ba20ac3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.282/claude-linux-x64.tar.gz"
      sha256 "2972e823268974dd084734d5f69fedc227eb4cb3bc9c398ceb7776280e836991"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
