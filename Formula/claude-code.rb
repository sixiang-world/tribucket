class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.292"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.292/claude-darwin-arm64.tar.gz"
      sha256 "7a7dcc508696a2093dfc690398b86217f12b07809b7bd534c2fde4f417881556"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.292/claude-darwin-x64.tar.gz"
      sha256 "09cae50768d6cfdc2c8b110e8417627c0b0c6950adfae0c5b000ebef18ecf6d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.292/claude-linux-arm64.tar.gz"
      sha256 "3b2b5f594bef12054b00e6cb61cddcc0900150e0a22a0ff822a0515bc17b1230"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.292/claude-linux-x64.tar.gz"
      sha256 "7045cd790b2c7b8cc6169d061aec7274d37a6a0d8ed318a6ff8868262433b1f9"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
