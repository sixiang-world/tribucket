class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.303"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.303/claude-darwin-arm64.tar.gz"
      sha256 "cf40802aba7ff81f3c9085b7016e181a9ad2bc2ea9afa0853bff2fd2b496855c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.303/claude-darwin-x64.tar.gz"
      sha256 "7397e7f71c68524cf9ff947c943378ed9eb48f6d293c101b287b85019e7c18f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.303/claude-linux-arm64.tar.gz"
      sha256 "0c219f6d5fadf1ce5771f7976fe18d6a57a9b8267def5198b58d3e121eeb98c1"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.303/claude-linux-x64.tar.gz"
      sha256 "9ef730488e8b75d47f23c156282a73c89db3342aaf756ed7ec0b78a88fb31f3e"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
