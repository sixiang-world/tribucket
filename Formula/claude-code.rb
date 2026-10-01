class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.287"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.287/claude-darwin-arm64.tar.gz"
      sha256 "43b83e4bf099f47efe590c8da0db43b33109c558ae81b8d1c7b1d024db86d6ef"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.287/claude-darwin-x64.tar.gz"
      sha256 "7a33c480c439702c7cb28c4614fc9178f3b08d18038472b74a8fb939570b092f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.287/claude-linux-arm64.tar.gz"
      sha256 "9b1f2996166948602b399cea6c11a654f52ac3b38c27142dfa4e6420e57eb3bd"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.287/claude-linux-x64.tar.gz"
      sha256 "627e578d436ebc12daf059c0379dee23f77c761fb7d2ad5de82645dc29b24372"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
