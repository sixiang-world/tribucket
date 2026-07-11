class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.207"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.207/claude-darwin-arm64.tar.gz"
      sha256 "42603b9b96c30a61da4a51c4c6e018db551c8605cd4e8b92777aa68ddaf88deb"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.207/claude-darwin-x64.tar.gz"
      sha256 "6afab88ee771f2ad2e67fd78f8b4ae0c1df9f100fddd86f49c064499c733ef99"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.207/claude-linux-arm64.tar.gz"
      sha256 "d656953866e463f9488105e59dff950040948672ff1a68f660b7cb4e96179e5c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.207/claude-linux-x64.tar.gz"
      sha256 "8315b69621c8fa391404bc62682e954c64245fa5f2fe3d528b5489cbb973c871"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
