class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.191"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.191/claude-darwin-arm64.tar.gz"
      sha256 "2028b75f8da24c3082d3d0982043d2bbd9bcaa462bb1a3fb6f4f200e7f1c834d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.191/claude-darwin-x64.tar.gz"
      sha256 "3bd3cdaf2c29f05db7e6144af89fd10a9f9b6cec027b6f832f8920372abcc3dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.191/claude-linux-arm64.tar.gz"
      sha256 "11a66299ddd81e40afe9720c67373be3bb8438c62f173cb48cbca907ca5b2151"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.191/claude-linux-x64.tar.gz"
      sha256 "555641c594a4ad0935cc866001fb82052eb5f1810035fead1f69a1ee30d16501"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
