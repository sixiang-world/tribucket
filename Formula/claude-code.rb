class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.238"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.238/claude-darwin-arm64.tar.gz"
      sha256 "342ca2606ee1f37c8ce9bc3e3b71b23b6f3fd48f9974f389cd71ec32c9c65858"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.238/claude-darwin-x64.tar.gz"
      sha256 "79e5a4707513ca9d0f811d400356faa58e80ae9add0809bacf641597e64d0f3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.238/claude-linux-arm64.tar.gz"
      sha256 "304d1cb6043935f2cd95e14b7a85843220d3e71afdd0dc8b1f4e90b574d4c9cb"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.238/claude-linux-x64.tar.gz"
      sha256 "1504400055a4427392cf27ccb3f93b4aa9566b6dadd1dfd98279cd25f79ce490"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
