class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.234"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.234/claude-darwin-arm64.tar.gz"
      sha256 "5466f6bca4e84ae7a9657acadd54b095a192452b52a444c7663bbfa75f98bb31"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.234/claude-darwin-x64.tar.gz"
      sha256 "5d566c5bdb9fc191fcfde937ea6bde13f12e93271f1e37db9f9c74d10649d350"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.234/claude-linux-arm64.tar.gz"
      sha256 "b88737009774d8682234767691f0445fcdb1e299f1ce7ecc96c427a1dd7b2228"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.234/claude-linux-x64.tar.gz"
      sha256 "74cef52476eb44b892317970cc854212e9d12f9abe678729de1ca50491563130"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
