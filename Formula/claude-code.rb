class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.183"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.183/claude-darwin-arm64.tar.gz"
      sha256 "5b79d7ec03cd98f8a81f7432368ea3b34cb456af63163f32003ce5f1e60bcaf9"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.183/claude-darwin-x64.tar.gz"
      sha256 "c098fb113acefda6cce6dfdeb68f735286b39f43d0fee16a2357ebea3f94f8f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.183/claude-linux-arm64.tar.gz"
      sha256 "090452b47ae10f3cff23dd00e473b035e126eb09f0c8315cce49c45dfb0155cd"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.183/claude-linux-x64.tar.gz"
      sha256 "9a67db09b82c37bb5e319d47bc15c2daf482d975f45676c95481134fea827084"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
