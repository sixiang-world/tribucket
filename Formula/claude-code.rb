class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.178"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.178/claude-darwin-arm64.tar.gz"
      sha256 "ff78edfd32f19b5730ba7af81866f0f5e194d59cfdfae47179f906ed8c7769d1"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.178/claude-darwin-x64.tar.gz"
      sha256 "841de148e5eb1e941e54b26b059ba8a7a9fbf55bb1b31e3e7a0051fac1b04fe4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.178/claude-linux-arm64.tar.gz"
      sha256 "28f3ca5e64667f9622a5c82577982ac5969fa8a95b89f327defb08c07b6dd574"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.178/claude-linux-x64.tar.gz"
      sha256 "77b0d33a8f53c7ab282337ebabbbe29c87f58d9c892095d40af608cce848fd3a"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
