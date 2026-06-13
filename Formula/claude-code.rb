class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.177"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.177/claude-darwin-arm64.tar.gz"
      sha256 "3c56625a875d0d45e85abce60420b97224fc457f79c4b53130f71a298fee81ab"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.177/claude-darwin-x64.tar.gz"
      sha256 "2181f521c8511af6370454dd6b4d7e1e76d35db4cbf2c51431b3756b1e74f83d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.177/claude-linux-arm64.tar.gz"
      sha256 "b95531bf2f5ae31d6a9203e7df8848c6b9715402f414d7603ba9b1a1109e778e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.177/claude-linux-x64.tar.gz"
      sha256 "091957f77ee7697589ddcf47391764ca1683cdfdeaa679c08120cf6584b19c51"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
