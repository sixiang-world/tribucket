class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.231"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.231/claude-darwin-arm64.tar.gz"
      sha256 "700144a0ba87ef77ef4c31428fd38f75832ee091ed310d5be15b1d72764a0d77"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.231/claude-darwin-x64.tar.gz"
      sha256 "9a4b29e7095d09898d473d84cd26a93044c45b9b9529fdbc95ddfaa06aa3f079"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.231/claude-linux-arm64.tar.gz"
      sha256 "3d2976940c34924cc87995a9dc1a4c22ca8ab5f6bf17e11eb98e49de16b1c0d0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.231/claude-linux-x64.tar.gz"
      sha256 "5b8c8f7c8d91f5be9f28991fb7eb035d01299982d9013aa514f7506b2c504a01"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
