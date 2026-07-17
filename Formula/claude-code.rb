class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.212"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.212/claude-darwin-arm64.tar.gz"
      sha256 "75e679c3a5c430a3d18476fa0dc2a1925696835557873747c93a85615a84cb0c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.212/claude-darwin-x64.tar.gz"
      sha256 "ad3a2b1814fa55f7c8feded061b51e52b3ff85ef56cb69aed7b15ca1072a2d10"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.212/claude-linux-arm64.tar.gz"
      sha256 "a0a28aaa9ecb96f55ffefd3b30a131d02034fef94fbc542a668e02732d92ee6b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.212/claude-linux-x64.tar.gz"
      sha256 "c80c34f0b45e820db7202417deb855b4b2fdfb03ae3cecd118aa5517f15e7e41"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
