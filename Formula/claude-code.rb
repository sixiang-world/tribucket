class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.323"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.323/claude-darwin-arm64.tar.gz"
      sha256 "89a467ec2efb5b34bd9bad1a99d9c29eda804de03de5e2f65d787b72b1502361"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.323/claude-darwin-x64.tar.gz"
      sha256 "0c08c4d786c101237f33e3e1fcaf193d8afe479ae4a9cd2db20f645815393b7a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.323/claude-linux-arm64.tar.gz"
      sha256 "808fa9c71caf7ebed9383d3e38bee6e7dd2fa80877ac12c6c27438786295099e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.323/claude-linux-x64.tar.gz"
      sha256 "522255678548859b9799b7b098c03a3aa286c9a9ede01957e35f4713ccc43631"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
