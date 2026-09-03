class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.259"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.259/claude-darwin-arm64.tar.gz"
      sha256 "2e9440dd56c919f962e8896c2b8f899b25cc020ebcad7aad702c85e7102d6422"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.259/claude-darwin-x64.tar.gz"
      sha256 "5513f60a87a24ede345d6a18497d4387e1959d1f0f66d795d6e0f3c9f37ff9fb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.259/claude-linux-arm64.tar.gz"
      sha256 "de20156d423cf3d5038e5df732a28e642921a51ec110fd3a8b6d0d25415e7358"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.259/claude-linux-x64.tar.gz"
      sha256 "f77fff577240f535c9c1b44dfef705280cb4809d6f0d50b6997f4965331ade34"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
