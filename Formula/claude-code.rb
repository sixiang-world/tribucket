class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.268"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.268/claude-darwin-arm64.tar.gz"
      sha256 "20e6377cdcd310abcd2f1fb567ccebee08edc40b2aae92c587ba212a940152a3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.268/claude-darwin-x64.tar.gz"
      sha256 "5cd2caca8c62956e07fd75794b5ed03a5639c51f0f1b2f7b955d9ca6798f839c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.268/claude-linux-arm64.tar.gz"
      sha256 "e9047c49d31f358af005198d77225b32468785ab28cacee815c42be314d335a8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.268/claude-linux-x64.tar.gz"
      sha256 "dfd082062904f36e695cafa16835e3214e93b7ed272c858069d2367d68dc3b02"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
