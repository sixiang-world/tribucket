class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.160"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.160/claude-darwin-arm64.tar.gz"
      sha256 "65db148c2162fc65fe39c1a1ec46886f68d6897b08021d54b3cdc3f0c9a4c93b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.160/claude-darwin-x64.tar.gz"
      sha256 "e531ea8bfd1fad031dadfb10d5cfbc1deeb7969f7a3e6d3fed5ba292856afdb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.160/claude-linux-arm64.tar.gz"
      sha256 "06244908bde09bdb1d807d02b5932be10520eb33b42111423fb48c6d8184742e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.160/claude-linux-x64.tar.gz"
      sha256 "827cf45f8be2290deb55edeadd7252921e486e8bc4bedd182649390dc87f4b47"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
