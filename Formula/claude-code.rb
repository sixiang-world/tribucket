class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.163"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.163/claude-darwin-arm64.tar.gz"
      sha256 "2eab405d6ab9638f6df0e3050a186695029e41dcc98b6bc60a2fe574f2cf96c5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.163/claude-darwin-x64.tar.gz"
      sha256 "fb14072464100a44c3f19eab06b1cf9a5de71f2aca91cf3ec49bd227c23720b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.163/claude-linux-arm64.tar.gz"
      sha256 "4f52446514640ce39ec78c52d954cb68db5f21a7a1135c15259be1a34603bc4c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.163/claude-linux-x64.tar.gz"
      sha256 "df04b06270beed39ddcdd29734d4dd63b7e6861511e40380b2921b25ccd2eaf7"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
