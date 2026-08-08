class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.226"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.226/claude-darwin-arm64.tar.gz"
      sha256 "3e59a330f12e9552fad2ad290bd470f54dc7a672643fff2dea6f9952b40622f2"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.226/claude-darwin-x64.tar.gz"
      sha256 "755f44fb5078ab990aa927e68dae06bf07aa5e102760cf6b85bf55c68a7b9db0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.226/claude-linux-arm64.tar.gz"
      sha256 "fe6a30d9358c6407780cc2045181ca7ecebe6f9967b99ac1a884f90694e825f5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.226/claude-linux-x64.tar.gz"
      sha256 "494eec4343283c149922ecdffcb271960b920d9ca9e238c0cdb35e1d96faaa2d"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
