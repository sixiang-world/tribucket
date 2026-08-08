class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.225"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.225/claude-darwin-arm64.tar.gz"
      sha256 "db3d502b64d5cb7dd9c14556706b7258a4470ae9d5896ecbaf709e49225bc8d3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.225/claude-darwin-x64.tar.gz"
      sha256 "5489fbf25bf67c398bc9272a6c236dc11de98c9077509f0df736d4466ce79ac8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.225/claude-linux-arm64.tar.gz"
      sha256 "a37b2db2d903a33d4c6707edc48cc6b2ace14b55ffb4c6665d298bd0aaf141c6"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.225/claude-linux-x64.tar.gz"
      sha256 "f7d40d0087ff9893546a1c0b5be8a0c6159a256f0b236b6c8d71396a527b75a7"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
