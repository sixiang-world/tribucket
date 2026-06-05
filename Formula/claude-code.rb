class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.165"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.165/claude-darwin-arm64.tar.gz"
      sha256 "6f5dcb1bce40388099ce7fb6a4d212e9795ee06baded0902175890608b3c1c06"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.165/claude-darwin-x64.tar.gz"
      sha256 "4dad1931ea91aa3c3062c9272444b8000cb8d001598d286d9a60b345b578362b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.165/claude-linux-arm64.tar.gz"
      sha256 "686e4aef159a1170f62c48e86e9185908b4f3f8a96b20221d753c513126482d0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.165/claude-linux-x64.tar.gz"
      sha256 "667ac26e4c9da3bd44632b4aa578e2874c06544c3775929a357bf2fe87709a25"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
