class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.311"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.311/claude-darwin-arm64.tar.gz"
      sha256 "28dc437c4530e4fbd5e4f8924119cb001c332b64de5e817b35898c39ec107155"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.311/claude-darwin-x64.tar.gz"
      sha256 "d35c77b739797451772b8179c076bd7230f456239bf538890fbc0b38ca209bde"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.311/claude-linux-arm64.tar.gz"
      sha256 "f464c31d01cd364d1d5df529dc4c202ce9a05c7a87b9fd4fefebb0a8ffe1ecb5"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.311/claude-linux-x64.tar.gz"
      sha256 "1e506d1d4466d854f0a2ea662f04122c77475e8c71a680bbbdc1c99fefff3fa7"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
