class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.326"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.326/claude-darwin-arm64.tar.gz"
      sha256 "4e27662f58b98ca3c5cbe67081891d2cc86461fbb285c22ed8309078a070671b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.326/claude-darwin-x64.tar.gz"
      sha256 "ffee46842d77f57d0f275b493e23f44413a7d3208a3347c7facc07a0ba6ec48e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.326/claude-linux-arm64.tar.gz"
      sha256 "61d9c24ad8aa6356e076753760641521d8c85f3e37a3641412eaae4d5885141f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.326/claude-linux-x64.tar.gz"
      sha256 "30f5542005d138d74eaba6af8de7a6678e71e87dc4ba929435ac2ff9011d5a53"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
