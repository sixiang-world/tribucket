class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.270"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.270/claude-darwin-arm64.tar.gz"
      sha256 "844b574a4f66103138a0d3090e7ef6117f83790b4d637c25a798057a735e68e9"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.270/claude-darwin-x64.tar.gz"
      sha256 "bfc4a3bb1f785e389035b7b49ac752e0fd92d908efdc6d1b4ec590e545c54730"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.270/claude-linux-arm64.tar.gz"
      sha256 "005d990a52bc16a5dd9ac51f2cc959f686a2c502b343b2eab92351ababf50f7f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.270/claude-linux-x64.tar.gz"
      sha256 "b069b327de3ad6c8cda70886675da46fb213797ac99a367df384e2202b37e0b7"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
