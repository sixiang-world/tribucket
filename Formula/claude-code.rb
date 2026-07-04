class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.201"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.201/claude-darwin-arm64.tar.gz"
      sha256 "edb45c0362e3a48e301978d595a4f0171dbf9401540657be2a2a7ea928ae3d9e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.201/claude-darwin-x64.tar.gz"
      sha256 "5564e53364c389b8c4dfbef67b30f42be033e53ae5cacc71f5a74db72a003fa3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.201/claude-linux-arm64.tar.gz"
      sha256 "9af73a1033733db6a65228bb3feb9f38eddbdd92da9ceb844cb7c97fb31f9539"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.201/claude-linux-x64.tar.gz"
      sha256 "0664deaffe62c24a57696b938b1556ab568d98db11e9be5da230169c8cc0015f"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
