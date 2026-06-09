class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.170"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.170/claude-darwin-arm64.tar.gz"
      sha256 "76353c44fd106a95f46bb35627943145fd67dcde003f6ffafe09517f8806a4b9"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.170/claude-darwin-x64.tar.gz"
      sha256 "afb9fa2dc924b62745ddf34390269f3fe9c467c46e75c2c0b35bb6fb65e83810"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.170/claude-linux-arm64.tar.gz"
      sha256 "aabbe2b0919e83afb3517265574eaf60b689dd1bf7ecf339dd6388b1a3a95ec2"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.170/claude-linux-x64.tar.gz"
      sha256 "daed69072014f1c60caae70b4a6cd266a57a75bd2c4fc2ab7760e6d2bf28e0f3"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
