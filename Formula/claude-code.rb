class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.269"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.269/claude-darwin-arm64.tar.gz"
      sha256 "c1649ec5235ac893c2055badc28347d28b9399ca641ad3c485b1c2432c2d6ccd"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.269/claude-darwin-x64.tar.gz"
      sha256 "c62ad73f946dec1001312e024b3a6cd46831356cae81f2a12a817df911fc844f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.269/claude-linux-arm64.tar.gz"
      sha256 "b6834b006482a17618ee41d790dd39eaed9aac10ea6efef190252bd029c84d2b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.269/claude-linux-x64.tar.gz"
      sha256 "2749b0fc61cb5ff9a998431d30e9e447a2214b4c5393708db0800245dd3733eb"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
