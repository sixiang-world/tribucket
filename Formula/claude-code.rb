class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.187"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.187/claude-darwin-arm64.tar.gz"
      sha256 "e222834d0b141eef80318493ec9f6d91bf98ab2f89e405f64ed5ebe5a2331cdc"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.187/claude-darwin-x64.tar.gz"
      sha256 "a1126c40462ea580b99d45c0bfc0a51bce4b9ad42d02360af5532225a34e4212"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.187/claude-linux-arm64.tar.gz"
      sha256 "3571357eef914788cc23b456e4e59fc90621554b06310e95c9fe5b291a08d6f0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.187/claude-linux-x64.tar.gz"
      sha256 "11a0f29122104c20660346fd54cc7219111d1a8428eccd433695096375b568d2"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
