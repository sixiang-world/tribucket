class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.246"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.246/claude-darwin-arm64.tar.gz"
      sha256 "65d7fd085d3a9d297e4300f78e5364ccf3c8f5f34351128da3a59e1e316a3f8c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.246/claude-darwin-x64.tar.gz"
      sha256 "bd25bfa4bdc9bc14fe842a79f5d5f96a86ad363bf9414fd6e941148ea980ff6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.246/claude-linux-arm64.tar.gz"
      sha256 "baeb4f7d0f459e1d1f11f2f7ff90efd666a0764188921385294c73753345ec08"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.246/claude-linux-x64.tar.gz"
      sha256 "45debae066f0eb96cd1c29536855294d4f1baf2eb55b147089724423a611a5df"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
