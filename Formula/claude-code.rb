class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.205"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.205/claude-darwin-arm64.tar.gz"
      sha256 "72e3f0d0aadf9e345d462cae864090740e4d816def456a3560af33d184d0060c"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.205/claude-darwin-x64.tar.gz"
      sha256 "a146774aaeee35344dd4879539f571971d3a84bda5dd373f4ab6b57b72f4a0e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.205/claude-linux-arm64.tar.gz"
      sha256 "5abda9d1ba6e5eab73f1f397af5a5cfd3a46f1276b658b60b41d77f14ae99c66"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.205/claude-linux-x64.tar.gz"
      sha256 "e9a5deea0fa1b7231c73db48d756ea1140eaa41b61ed42c69299ce9e5f3d6430"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
