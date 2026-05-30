class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.158"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.158/claude-darwin-arm64.tar.gz"
      sha256 "790e1b984cc1b72cdb1d98a4c47d8f61f939e8ea4ffa80c0ef1ac45083743e56"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.158/claude-darwin-x64.tar.gz"
      sha256 "fb19106eda0d905f0e138af4ad5157738e18046502f321ed3507ad44a2a562bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.158/claude-linux-arm64.tar.gz"
      sha256 "6392dc5202e9dbea06ed3410b7e4eec7530cb5ae1743715f4b71b7230241a932"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.158/claude-linux-x64.tar.gz"
      sha256 "2ba815666a2f060ee1490f5218eecef11c7ff6fa2f85377316279fcfccb04340"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
