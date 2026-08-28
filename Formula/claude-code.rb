class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.251"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.251/claude-darwin-arm64.tar.gz"
      sha256 "02e1e8f41406ae4f4a6b85f25ce6653bf586478dfe64e4d56e0a21624756141d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.251/claude-darwin-x64.tar.gz"
      sha256 "da2b0b631cd3af3053d18aa27c5cfc5626a4ffdb0f92d1b63bca7b85a5edfe80"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.251/claude-linux-arm64.tar.gz"
      sha256 "53a4cc28612c6534884019223ee38b9bad5a12814fe8e31d42ea26ff2b169373"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.251/claude-linux-x64.tar.gz"
      sha256 "4fda59f47ab17c0e0c831b3144e3025c050397ba37d574388f52e92e1af81c74"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
