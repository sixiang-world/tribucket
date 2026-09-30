class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.286"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.286/claude-darwin-arm64.tar.gz"
      sha256 "0b0333f25613cf8ba8035f6c806abc45c72b2bdd4dc8ef59ce7582a2a0e76744"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.286/claude-darwin-x64.tar.gz"
      sha256 "9b4fd1e81fb2c37690eb00b332d0e24110f10b8e32824caa13245f873363db3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.286/claude-linux-arm64.tar.gz"
      sha256 "8e37600d9a94d9706a6223801203515a38e5494d0baffd567c93a7c1a86608ab"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.286/claude-linux-x64.tar.gz"
      sha256 "ce19bf64fa7e1bc27c1607a8119cc7167f926f363c85b0983a4516a505b330b3"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
