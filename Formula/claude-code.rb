class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.218"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.218/claude-darwin-arm64.tar.gz"
      sha256 "86fb6010adaf8bb91d1967f0423bc485b9a3e7cd4f2b731ef6c32039be868124"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.218/claude-darwin-x64.tar.gz"
      sha256 "9cb2ae7a9e5c7c4e8fb73dcbcd7a381b7bf6e34e97d4b198ba5bd4a9a017a050"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.218/claude-linux-arm64.tar.gz"
      sha256 "15c3d42a60170aa93d4335d7c1466d6c877ddb6c8d360a7081d222d4b1390223"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.218/claude-linux-x64.tar.gz"
      sha256 "7b7af9375bbd9dd5ec02d0b193b7f6fbbdd08fc6e6964426c1e4f537fc9161c3"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
