class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.274"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.274/claude-darwin-arm64.tar.gz"
      sha256 "2be8926f06785d3d4c072a32d83b48c7e02b40ee955bd30600aacaaa77f02c93"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.274/claude-darwin-x64.tar.gz"
      sha256 "512a54e5c17c27b331c1a1e08a1c9f638e2b80fbdd1dbd99b7bf1997e893b0fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.274/claude-linux-arm64.tar.gz"
      sha256 "3cf0b1909d4c9186b7f3e7b84ea37711faade845b63b160b513d4144a95ac4b5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.274/claude-linux-x64.tar.gz"
      sha256 "d64c8b6c7e10cd5b99e6ecbcef2d64c9ca4b6804f788e9d7622d5535a99193a2"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
