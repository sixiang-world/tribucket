class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.265"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.265/claude-darwin-arm64.tar.gz"
      sha256 "c628cda00c0c824247890547dd35f21c95b7da9c4a10be4d2ac9ac30d42cb4c1"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.265/claude-darwin-x64.tar.gz"
      sha256 "8c143db00ccd3ae194af2b17849616423ea07ff7455d4968f8eed22e3564addb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.265/claude-linux-arm64.tar.gz"
      sha256 "eb7d23dddfe0a3fc937c3a3b2922bc71667812f1e7989592275ec4a0c772e58e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.265/claude-linux-x64.tar.gz"
      sha256 "e167347607ab1ca9751bc904fc85207f737951003de4617a278ff79324e65d1e"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
