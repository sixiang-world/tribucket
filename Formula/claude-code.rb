class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.162"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.162/claude-darwin-arm64.tar.gz"
      sha256 "5546226d4cf4bade4940f6a198643ad512c2d1a4f1c89ad494c78af07d2ff965"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.162/claude-darwin-x64.tar.gz"
      sha256 "1d7abbb89b9dd0e3350eb4b4d7a2092a4e6628c3dcb537cc42c2b89c60b32516"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.162/claude-linux-arm64.tar.gz"
      sha256 "1cb8094bdf3fc08707b22ab7917e816d7bbf356c19818468dc49900f633c0585"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.162/claude-linux-x64.tar.gz"
      sha256 "74579298693b79110020992965e3abfba5f88fd0f49242fcd7c9e7f0ef428a18"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
