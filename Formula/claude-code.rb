class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.173"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.173/claude-darwin-arm64.tar.gz"
      sha256 "4db2313c2e92d21eb7767c1b12431785877339e6389366736b07bcc5a031dcfe"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.173/claude-darwin-x64.tar.gz"
      sha256 "a3da948a15ae899df6540abc33030f514595f1ce082e5544f640ee1036550caf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.173/claude-linux-arm64.tar.gz"
      sha256 "2f0038e9f7b3ee049e7db202b4f10af7d2e62af542b7fd7d1f542ea04166a4fe"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.173/claude-linux-x64.tar.gz"
      sha256 "b3d1afba5c02fa0fed43150e9470e556cf0cfc3a5c27d836a199d54051c96390"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
