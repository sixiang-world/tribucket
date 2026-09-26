class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.283"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.283/claude-darwin-arm64.tar.gz"
      sha256 "033f733e135ecd00aeec18ea8990a87a0fd8be220b20548353fd025351a0a9b3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.283/claude-darwin-x64.tar.gz"
      sha256 "ac07dcae42aa355bb6915c5e429d29ad2a797e1ab309527eebef3bfd20b39c79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.283/claude-linux-arm64.tar.gz"
      sha256 "a2e7d497d40041d7eca8f8fd1d77405a6501ff8b1a61fa02a0e95c458824a43e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.283/claude-linux-x64.tar.gz"
      sha256 "db404a91bec8baffb53463166fdc8bf579208a527d60afc2d984d7507dc0c2f9"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
