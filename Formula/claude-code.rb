class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.295"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.295/claude-darwin-arm64.tar.gz"
      sha256 "dfbbe96007c69d7bc8631c5f4d7596e960cb0962f8d13efea7d4239f4caa3917"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.295/claude-darwin-x64.tar.gz"
      sha256 "7b0ae32560b75062ea3a93b157d08defc406dbd1fb8a5ea59acdff5d169e8f31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.295/claude-linux-arm64.tar.gz"
      sha256 "a22d704eca7f241476445dfeb001c1848c1ebb6251e583be3dccfbfb1a5fd4aa"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.295/claude-linux-x64.tar.gz"
      sha256 "cf9cfb714ded1f27c1d3b7fb274faef50d72312c4b14525a74659188f59bd8b1"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
