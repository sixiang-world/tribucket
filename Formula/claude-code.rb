class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.317"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.317/claude-darwin-arm64.tar.gz"
      sha256 "d550cb26bfbbdb79052435544f7edc090c2b02f5fd9b30431bfb98d07a4bb318"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.317/claude-darwin-x64.tar.gz"
      sha256 "88cd97306115aa7efde383002f4ebb385cc119828b870012be0670dd88f12e90"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.317/claude-linux-arm64.tar.gz"
      sha256 "b7ab2311a8d5f4041045e63685af49ebaffcbb121fe572afdb9080a3b4f42711"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.317/claude-linux-x64.tar.gz"
      sha256 "153511cf79cd27c55c9f9c919cc532eb90647f7893cb3f4e78dac776991714e0"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
