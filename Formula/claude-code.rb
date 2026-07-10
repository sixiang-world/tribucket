class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.206"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.206/claude-darwin-arm64.tar.gz"
      sha256 "df413a933b0ea8914f83df88fee62932cbfdbec879b74af91f8f34963e124eaf"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.206/claude-darwin-x64.tar.gz"
      sha256 "e6b1ea0af51163cc337646c2e29fffcdf4caf134bdde238f6e68f7fa502eade4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.206/claude-linux-arm64.tar.gz"
      sha256 "0aae7820e5a4f8058ca4231e6f5ca2146507467749d21a143ed5eefd5799f723"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.206/claude-linux-x64.tar.gz"
      sha256 "9e405558ebfa0cb7841ff296c75988f7c7569e4fbad2052df029b43f687134b2"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
