class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.195"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.195/claude-darwin-arm64.tar.gz"
      sha256 "a8787ad17b704455b3d729acd37895c0fe8348587f94d962c1064d620488594a"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.195/claude-darwin-x64.tar.gz"
      sha256 "aa88ad4d1a42a0bd2ea1b699a11b5692e70a6d057b50a84b0bddff6492f969bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.195/claude-linux-arm64.tar.gz"
      sha256 "b82baf63acc761d53e4d846bc3c8eb96a91843a03f0d3a3b94a756e4a664c2ab"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.195/claude-linux-x64.tar.gz"
      sha256 "3139d169ddde072e38f93d69289e4ef0f808157cfd1d2e87cbb164a275e3c20b"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
