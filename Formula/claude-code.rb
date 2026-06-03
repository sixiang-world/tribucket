class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.161"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.161/claude-darwin-arm64.tar.gz"
      sha256 "7a6b183a353fc96ea9058f744432f5688a04724d9edd8767c9130375d34b0e1e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.161/claude-darwin-x64.tar.gz"
      sha256 "417ad067f2f23f43027a6b3f3270095a1b56467c1e3b669509da66320777fab6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.161/claude-linux-arm64.tar.gz"
      sha256 "ad3cbe3f9bc91dfa1fc8afdba093180a7d7106bcc154836feaeebd7dc7897399"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.161/claude-linux-x64.tar.gz"
      sha256 "5f20d8d7eeb1646afc02df7740c13c8da4b3c83554d6e2d63b9450ee160e3248"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
