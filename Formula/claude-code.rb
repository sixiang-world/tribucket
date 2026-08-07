class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.224"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.224/claude-darwin-arm64.tar.gz"
      sha256 "7a0228c95b8a5d5ac088c03cfe3810facd9de89343dc4a892dc79c841aec1416"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.224/claude-darwin-x64.tar.gz"
      sha256 "d1b576e477db262d45705b1a1f3542c4fe3801b9762a7c65a1250729c1594f78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.224/claude-linux-arm64.tar.gz"
      sha256 "6f72188d3593111b4a8e6d738844209ce42f94275f9d5981f3123d462a66c157"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.224/claude-linux-x64.tar.gz"
      sha256 "75d6f64bcd2d16bad0825a8e8c746702513b375c47484a373f0b057ff49918e7"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
